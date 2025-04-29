extends Node3D
@export var enabled: bool = false
@export var speed: float = 30.0
@export var return_speed: float = 45.0
@export var curve_width: float = 5.0 # Width of the horizontal curve
@export var curve_direction: float = 1.0 # 1.0 curves right, -1.0 curves left
@export var original_parent: Node3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fire: bool = false
@onready var return_to_player: bool = false
@onready var static_collision_shape: CollisionShape3D = $StaticBody3D/CollisionShape3D
@export var parent: Node3D
@export var target: Node3D

@onready var mesh: MeshInstance3D = $mesh
enum State {IDLE, THROW, RETURN}
var state: State = State.IDLE
var initial_throw_pos: Vector3
var target_pos: Vector3
var throw_progress: float = 0.0
var curve_normal: Vector3

func _ready() -> void:
	original_parent = get_parent()

func _process(_delta: float) -> void:
	if Input.is_action_just_released("shoot") and state == State.IDLE:
		start_throw()

	if Input.is_action_just_pressed("recall") and state == State.THROW:
		state = State.RETURN
	
	if state == State.THROW:
		throw_boomerang(_delta)
	
	if state == State.RETURN:
		return_boomerang(_delta)
	
	if state == State.IDLE:
		animation_player.stop()
		mesh.rotation.z = 51.4
		rotation.x = 0
		rotation.y = 0
		rotation.z = 0

func start_throw() -> void:
	state = State.THROW
	initial_throw_pos = global_position
	if target:
		target_pos = target.global_position
	else:
		target_pos = global_position + -transform.basis.z * 20.0
	
	var throw_direction = (target_pos - initial_throw_pos).normalized()
	curve_normal = throw_direction.cross(Vector3.UP) * curve_direction
	throw_progress = 0.0

func throw_boomerang(_delta):
	static_collision_shape.disabled = false
	if !top_level:
		top_level = true
	if animation_player.current_animation != "inverse_rotate":
		animation_player.play("inverse_rotate")
	
	throw_progress += speed * _delta / global_position.distance_to(target_pos)
	throw_progress = clamp(throw_progress, 0.0, 1.0)
	
	var start_to_target = target_pos - initial_throw_pos
	var halfway = initial_throw_pos + start_to_target * 0.5
	var side_offset = curve_normal * curve_width
	
	var a = initial_throw_pos.lerp(halfway + side_offset, throw_progress)
	var b = (halfway + side_offset).lerp(target_pos, throw_progress)
	global_position = a.lerp(b, throw_progress)
	
	if throw_progress >= 1.0:
		state = State.RETURN

func return_boomerang(delta):
	static_collision_shape.disabled = true
	if animation_player.current_animation != "rotate":
		animation_player.play("rotate")
	
	if original_parent:
		var direction = (original_parent.global_position - global_position).normalized()
		position += direction * return_speed * delta

		if global_position.distance_to(original_parent.global_position) < 0.5:
			top_level = false
			global_position = original_parent.global_position
			state = State.IDLE

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("boomerang_return"):
		if state == State.RETURN:
			top_level = false
			state = State.IDLE
			global_position = original_parent.global_position
