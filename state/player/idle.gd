extends Node


var player: Player
func enter_state():
	player = get_parent().player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_state(delta: float) -> void:
	if player.animation_player.current_animation != "idle":
		player.animation_player.play("idle")
	if Input.is_action_just_pressed("up"):
		get_parent().set_state("Run")

func handle_input(event: InputEvent):
	print("handling input")
	get_parent().set_state("Run")

func exit_state():
	print("exiting idle state")
