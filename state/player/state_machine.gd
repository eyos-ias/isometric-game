extends Node

@export var initial_state: String
@export var current_state: Node = null
@onready var animation_player: AnimationPlayer = $'../visuals/AnimationPlayer'
@onready var ray_cast_3d: RayCast3D = $'../RayCast3D'
@onready var camera_holder: Node3D = $'../CameraHolder'
@onready var collision_shape_3d: CollisionShape3D = $'../CollisionShape3D'
@onready var laser_sound: AudioStreamPlayer3D = $'../LaserSound'
@export var player: CharacterBody3D

func _ready() -> void:
	print("state machine ready")
	# player = get_parent()


func _process(delta: float) -> void:
	if current_state:
		current_state.update_state(delta)

func set_state(state_name: String):
	if current_state:
		current_state.exit_state()
	current_state = get_node(state_name)
	# state_label.text = state_name
	current_state.enter_state()

func update_state(delta: float):
	if current_state:
		current_state.update_state(delta)

func handle_input(event: InputEvent):
	if current_state:
		current_state.handle_input(event)
