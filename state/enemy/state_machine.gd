extends Node

@export var initial_state: String
@export var current_state: Node = null
var player
@onready var state_label: Label3D = $"../StateLabel/Label3D"

func _ready() -> void:
	player = get_parent().get_parent().get_node("Player")
	# print("player from state machine", get_parent().get_parent().get_node("Player"))
	set_state(initial_state)
	
func _process(delta: float) -> void:
	if current_state:
		current_state.update_state(delta)

func set_state(state_name: String):
	if current_state:
		current_state.exit_state()
	current_state = get_node(state_name)
	state_label.text = state_name
	current_state.enter_state()

func update_state(delta: float):
	if current_state:
		current_state.update_state(delta)
