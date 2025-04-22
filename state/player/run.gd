extends Node

var player: Player

func enter_state():
	player = get_parent().player
	print("player: ", player)
	print("entering run state")
	player.animation_player.play("running")

func update_state(delta: float):
	# Get input direction
	if player.animation_player.current_animation != "running":
		player.animation_player.play("running")
	var input_dir := Input.get_vector("up", "down", "right", "left")
	
	if not player.is_on_floor():
		player.velocity.y = move_toward(player.velocity.y, -10, 20 * delta)

	if input_dir == Vector2.ZERO:
		get_parent().set_state("Idle")
		return
	
	if Input.is_action_just_released("ui_accept"):
		get_parent().set_state("Roll")
		return
	
	player.handle_movement(input_dir, delta)


func exit_state():
	print("exiting run state")

func handle_input(event: InputEvent):
	if event:
		pass
	print("handling input desu")
