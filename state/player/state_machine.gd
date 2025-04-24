extends Node

@export var initial_state: String = "Idle"
@export var current_state: Node = null
@onready var animation_player: AnimationPlayer = $'../visuals/AnimationPlayer'
@onready var ray_cast_3d: RayCast3D = $'../RayCast3D'
@onready var camera_holder: Node3D = $'../CameraHolder'
@onready var collision_shape_3d: CollisionShape3D = $'../CollisionShape3D'
@onready var laser_sound: AudioStreamPlayer3D = $'../LaserSound'
@export var player: Player
@onready var debugging: Sprite3D = $'../Debugging'
@onready var label_3d: Label3D = $'../Debugging/Label3D'


func init() -> void:
	player = get_parent()
	if initial_state and not current_state:
		set_state(initial_state)


func set_state(state_name: String):
	print("Switching to state: ", state_name)
	if current_state:
		current_state.exit_state()
	current_state = get_node(state_name)
	current_state.enter_state()
	label_3d.text = state_name

func update_state(delta: float):
	if current_state:
		current_state.update_state(delta)

func handle_input(event: InputEvent):
	if current_state:
		current_state.handle_input(event)
