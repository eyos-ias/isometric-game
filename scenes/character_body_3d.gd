extends CharacterBody3D

@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5

@export var mouse_sensitivity := 0.005
@onready var camera_holder = $CameraHolder
@export var world: Node3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(event.relative.x * mouse_sensitivity)
		camera_holder.rotate_y(-event.relative.x * mouse_sensitivity)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, -10, 20 * delta)

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_released("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	
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
