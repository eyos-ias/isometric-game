extends Node

var player: Player

func enter_state():
	print("entering roll state")

	player = get_parent().player
	player.animation_player.play("rolling")
	player.velocity.x = 0
	player.velocity.z = 0

func update_state(delta: float):
	pass

func exit_state():
	print("exiting roll state")

func handle_input(event: InputEvent):
	if event:
		pass

func on_animation_finished():
	get_parent().set_state("Idle")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "rolling":
		get_parent().set_state("Idle")

func start_movement():
	print("starting roll")
	# Get the direction the player is facing
	var forward_dir = Vector3(
		sin(player.visuals.global_rotation.y),
		0,
		cos(player.visuals.global_rotation.y)
	).normalized()
	
	# Apply velocity in that direction
	player.velocity.x = forward_dir.x * player.SPEED * 1.3
	player.velocity.z = forward_dir.z * player.SPEED * 1.3

func end_movement():
	print("ending roll")
	# Stop the rolling movement
	player.velocity.x = 0
	player.velocity.z = 0
