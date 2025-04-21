extends Node

@export var initial_state: String
@export var current_state: Node = null
@onready var animation_player: AnimationPlayer = $'../visuals/AnimationPlayer'
@onready var ray_cast_3d: RayCast3D = $'../RayCast3D'

func _ready() -> void:
	set_state(initial_state)
	
func _process(delta: float) -> void:
	if current_state:
		current_state.update_state(delta)

func set_state(state_name: String):
	if current_state:
		current_state.exit_state()
	current_state = get_node(state_name)
	current_state.enter_state()


func update_state(delta: float):
	if current_state:
		current_state.update_state(delta)