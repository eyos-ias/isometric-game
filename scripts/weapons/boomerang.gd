extends Node3D
@export var enabled: bool = false
@export var speed: float = 30.0
@export var return_speed: float = 45.0
@export var boomerand_range: float = 20.0
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
func _ready() -> void:
	original_parent = get_parent()


func _process(_delta: float) -> void:
	if state == State.THROW:
		var distance = global_position.distance_to(original_parent.global_position)
		print("Boomerang distance: ", distance)
		if distance > boomerand_range:
			state = State.RETURN

	
	if Input.is_action_just_released("shoot") and state == State.IDLE:
		state = State.THROW

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

func throw_boomerang(_delta):
	static_collision_shape.disabled = false
	if !top_level:
		top_level = true
	if animation_player.current_animation != "inverse_rotate":
		animation_player.play("inverse_rotate")
	position += transform.basis * Vector3(0, 0, speed) * -1 * _delta


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
			print("CLOSE ENOUGH")

	print("return boomerang")


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("boomerang_return"):
		if state == State.RETURN:
			top_level = false
			state = State.IDLE
			global_position = original_parent.global_position
			print("RETURNED")
