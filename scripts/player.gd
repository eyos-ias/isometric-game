extends CharacterBody3D
class_name Player
@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var mouse_sensitivity := 0.005
@onready var camera_holder = $CameraHolder
@export var world: Node3D
@onready var raycast: RayCast3D = $RayCast3D
@onready var crosshair: Sprite3D = $RayCast3D/crosshair
@onready var aim_sphere: MeshInstance3D = $RayCast3D/aim_sphere
@export var bullet_scene: PackedScene
@onready var laser_sound: AudioStreamPlayer3D = $LaserSound
@onready var animation_player: AnimationPlayer = $visuals/AnimationPlayer
@onready var visuals: Node3D = $visuals
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var state_machine = $StateMachine
@onready var debugging: Sprite3D = $Debugging


var target_x = 0.0
var initial_target_x = 0.0

func _ready() -> void:
	target_x = aim_sphere.position.x
	initial_target_x = aim_sphere.position.x
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	visuals.top_level = true
	update_visuals_position()
	
	state_machine.player = self
	state_machine.set_state("Idle")

func update_visuals_position() -> void:
	var player_pos = global_position
	var height_offset = 0.0
	if collision_shape:
		if collision_shape.shape is CapsuleShape3D:
			height_offset = collision_shape.shape.height / 2
		elif collision_shape.shape is BoxShape3D:
			height_offset = collision_shape.shape.size.y / 2

	visuals.global_position = Vector3(player_pos.x, player_pos.y - height_offset, player_pos.z)

func _input(event):
	handle_aim(event)

	state_machine.handle_input(event)

func _process(delta: float) -> void:
	aim_sphere.position.x = lerp(aim_sphere.position.x, target_x, 8 * delta)
	update_visuals_position()

func _physics_process(delta: float) -> void:
	debugging.set_rotation(-rotation)

	state_machine.update_state(delta)

	#move_and_slide()

	if not is_on_floor():
		velocity.y = move_toward(velocity.y, -10, 20 * delta)

	# if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	# 	velocity.y = JUMP_VELOCITY

	if Input.is_action_just_released("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_just_released("shoot"):
		laser_sound.play()
		shoot_bullet()


func shoot_bullet():
	if world:
		print("can shoot")
		var bullet_instance = bullet_scene.instantiate()
		bullet_instance.global_transform = raycast.global_transform
		
		world.add_child(bullet_instance)
	else:
		print("can't shoot")

func handle_movement(input_dir: Vector2, delta: float) -> void:
	if input_dir != Vector2.ZERO:
		var isometric_dir := Vector3(
			input_dir.x - input_dir.y,
			0,
			input_dir.x + input_dir.y
		).normalized()
		velocity.x = isometric_dir.x * SPEED
		velocity.z = isometric_dir.z * SPEED
		
		# Rotate visuals towards movement direction for isometric view
		var target_rotation = atan2(isometric_dir.x, isometric_dir.z)
		# Smoothly rotate the visuals to face movement direction
		# Using global_rotation to make it independent of parent rotation
		visuals.global_rotation.y = lerp_angle(visuals.global_rotation.y, target_rotation, 10 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		
	move_and_slide()

func handle_aim(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			print("toggle visibility")
			aim_sphere.visible = !aim_sphere.visible
			crosshair.visible = !crosshair.visible
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			print("Mouse wheel up")
			crosshair.position.x += 0.08
			target_x += 0.05
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			print("Mouse wheel down")
			target_x -= 0.08
			target_x = max(initial_target_x / 2, target_x)
			crosshair.position.x -= 0.05

	if event is InputEventMouseMotion:
		rotate_y(event.relative.x * mouse_sensitivity)
		camera_holder.rotate_y(-event.relative.x * mouse_sensitivity)
