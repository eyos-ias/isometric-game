extends Node

var player: Player
var play_slide: bool = false

@export var slide_speed: float = 20.0
@export var slide_duration: float = 0.7
var slide_timer: float = 0.0
var slide_direction: Vector3 = Vector3.ZERO

func enter_state():
	player = get_parent().player
	player.animation_player.animation_finished.connect(_on_animation_finished_handler)
	player.animation_player.play("slide_start")
	
	var input_dir := Input.get_vector("up", "down", "right", "left")
	
	if input_dir != Vector2.ZERO:
		slide_direction = Vector3(
			input_dir.x - input_dir.y,
			0,
			input_dir.x + input_dir.y
		).normalized()
	else:
		slide_direction = - player.visuals.global_transform.basis.z
	
	slide_timer = 0.0

func update_state(delta: float) -> void:
	slide_timer += delta
	
	if player.animation_player.current_animation != "sliding" and play_slide:
		player.animation_player.play("sliding")
	
	player.velocity = slide_direction * slide_speed
	
	if not player.is_on_floor():
		player.velocity.y -= 9.8 * delta
	
	player.move_and_slide()
	
	var target_rotation = atan2(slide_direction.x, slide_direction.z)
	player.visuals.global_rotation.y = lerp_angle(
		player.visuals.global_rotation.y,
		target_rotation,
		10 * delta
	)
	
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
