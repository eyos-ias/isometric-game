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
	# Get input direction
	var input_dir := Input.get_vector("up", "down", "right", "left")
	
	if input_dir == Vector2.ZERO:
		# If no input, use facing direction
		var forward_dir = Vector3(
			sin(player.visuals.global_rotation.y),
			0,
			cos(player.visuals.global_rotation.y)
		).normalized()
		
		player.velocity.x = forward_dir.x * player.SPEED * 1.3
		player.velocity.z = forward_dir.z * player.SPEED * 1.3
		# Keep visuals facing the same direction
		player.visuals.global_rotation.y = player.visuals.global_rotation.y
	else:
		# Use input direction for isometric movement
		var isometric_dir := Vector3(
			input_dir.x - input_dir.y,
			0,
			input_dir.x + input_dir.y
		).normalized()
		
		player.velocity.x = isometric_dir.x * player.SPEED * 1.3
		player.velocity.z = isometric_dir.z * player.SPEED * 1.3
		
		# Rotate visuals to face movement direction
		var target_rotation = atan2(isometric_dir.x, isometric_dir.z)
		player.visuals.global_rotation.y = target_rotation

func end_movement():
	print("ending roll")
	# Stop the rolling movement
	player.velocity.x = 0
	player.velocity.z = 0
