class_name PlayerState
extends Node
var player: Player
func enter_state():
	player = get_parent().player


func update_state(delta: float):
	pass

func exit_state():
	pass

func handle_input(event: InputEvent):
	pass