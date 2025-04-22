extends Node

var player: Player

func enter_state():
	print("entering run state")
	player.animation_player.play("running")

func update_state(delta: float):
	# Check if no movement keys are being pressed
	if not Input.is_action_pressed("left") and not Input.is_action_pressed("right") and not Input.is_action_pressed("up") and not Input.is_action_pressed("down"):
		get_parent().set_state("Idle")


func exit_state():
	print("exiting run state")


func handle_input(event: InputEvent):
	pass