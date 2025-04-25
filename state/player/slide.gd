extends Node

var player: Player
var play_slide: bool = false

# Slide parameters - adjust these to change how sliding feels
@export var slide_speed: float = 10.0 # How fast the slide moves
@export var slide_duration: float = 0.7 # How long the slide lasts in seconds
var slide_timer: float = 0.0 # Timer for tracking slide duration
var slide_direction: Vector3 = Vector3.ZERO # Direction of the slide

func enter_state():
	player = get_parent().player
	player.animation_player.animation_finished.connect(_on_animation_finished_handler)
	player.animation_player.play("slide_start")
	
	# Get input direction when slide starts
	var input_dir := Input.get_vector("up", "down", "right", "left")
	
	# If we have input, use it for slide direction
	if input_dir != Vector2.ZERO:
		# Convert to isometric direction
		slide_direction = Vector3(
			input_dir.x - input_dir.y,
			0,
			input_dir.x + input_dir.y
		).normalized()
	else:
		# If no input, slide in the direction player is facing
		slide_direction = - player.visuals.global_transform.basis.z
	
	# Reset slide timer
	slide_timer = 0.0

func update_state(delta: float) -> void:
	# Update slide timer
	slide_timer += delta
	
	# Handle the sliding animation
	if player.animation_player.current_animation != "sliding" and play_slide:
		player.animation_player.play("sliding")
	
	# Apply slide movement
	player.velocity = slide_direction * slide_speed
	
	# Apply gravity
	if not player.is_on_floor():
		player.velocity.y -= 9.8 * delta
	
	# Move the player
	player.move_and_slide()
	
	# Update visuals rotation to face slide direction
	var target_rotation = atan2(slide_direction.x, slide_direction.z)
	player.visuals.global_rotation.y = lerp_angle(
		player.visuals.global_rotation.y,
		target_rotation,
		10 * delta
	)
	
	# End slide if button released or timer expired
	if Input.is_action_just_released("slide") or slide_timer >= slide_duration:
		play_slide = false
		player.animation_player.play_backwards("slide_end")
	
func handle_input(event: InputEvent):
	pass

func exit_state():
	player.animation_player.animation_finished.disconnect(_on_animation_finished_handler)

func _on_animation_finished_handler(anim_name: String):
	if anim_name == "slide_start":
		player.animation_player.play("sliding")
		play_slide = true
	if anim_name == "slide_end":
		get_parent().set_state("Run")
