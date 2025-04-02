extends CharacterBody3D

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

var target_x = 0.0
var initial_traget_x = 0.0
func _ready() -> void:
	target_x = aim_sphere.position.x
	initial_traget_x = aim_sphere.position.x
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			print("toggle visibility")
			aim_sphere.visible = !aim_sphere.visible
			crosshair.visible = !crosshair.visible
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			print("Mouse wheel up")
			#aim_sphere.position.x += 0.05
			crosshair.position.x += 0.08
			target_x += 0.05
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			print("Mouse wheel down")
			#aim_sphere.position.x -= 0.05
			target_x -= 0.08
			target_x = max(initial_traget_x/2, target_x)
			crosshair.position.x -=0.05

	if event is InputEventMouseMotion:
		rotate_y(event.relative.x * mouse_sensitivity)
		camera_holder.rotate_y(-event.relative.x * mouse_sensitivity)

func _process(delta: float) -> void:
	aim_sphere.position.x = lerp(aim_sphere.position.x, target_x, 8 * delta)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, -10, 20 * delta)

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_released("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.is_action_just_released("shoot"):
		laser_sound.play()
		shoot_bullet()
	
	var input_dir := Input.get_vector("up", "down", "right", "left")
	if input_dir != Vector2.ZERO:
		var isometric_dir := Vector3(
			input_dir.x - input_dir.y,
			0,
			input_dir.x + input_dir.y
		).normalized()
		velocity.x = isometric_dir.x * SPEED
		velocity.z = isometric_dir.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func shoot_bullet():
	if world:
		print("can shoot")
		var bullet_instance = bullet_scene.instantiate()
		bullet_instance.global_transform = raycast.global_transform
		
		world.add_child(bullet_instance)
	else:
		print("can't shoot")

# func shoot_bullet():
# 	if bullet_scene and canShoot:
# 		# print("this is shooting")
# 		shooting_sfx.play()
# 		var bullet_instance = bullet_scene.instantiate()
# 		bullet_instance.global_transform = bulletSpawner.global_transform
# 		get_parent().add_child(bullet_instance)
# 		# add_child(bullet_instance)
# 		canShoot = false
		
# 		gun.get_node("AnimationPlayer").play("shoot")
		
# 		shootTimer.start()
