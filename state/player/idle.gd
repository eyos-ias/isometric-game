extends Node

var player: Player

func enter_state():
	print("entering idle state")
	
	player = get_parent().player
	print("player: ", player)
	player.velocity.x = 0
	player.velocity.z = 0
	player.animation_player.play("idle")

func update_state(delta: float) -> void:
	if player.animation_player.current_animation != "idle":
		player.animation_player.play("idle")
	player.velocity.x = 0
	player.velocity.z = 0
	if not player.is_on_floor():
		player.velocity.y = move_toward(player.velocity.y, -10, 20 * delta)
	var input_dir := Input.get_vector("up", "down", "right", "left")
	if input_dir != Vector2.ZERO:
		get_parent().set_state("Run")
		return
	if Input.is_action_just_released("ui_accept"):
		get_parent().set_state("Roll")


func handle_input(event: InputEvent):
	if event:
		pass


func exit_state():
	print("exiting idle state")
