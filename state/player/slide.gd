extends Node


var player: Player

var play_slide: bool = false

func enter_state():
	player = get_parent().player
	player.animation_player.animation_finished.connect(_on_animation_finished)
	player.animation_player.play("slide_start")

func update_state(delta: float) -> void:
	if player.animation_player.current_animation != "sliding" and play_slide:
		player.animation_player.play("sliding")
	
	if Input.is_action_just_released("slide"):
		play_slide = false
		player.animation_player.play("slide_end")
	
		
func handle_input(event: InputEvent):
	pass

func exit_state():
	pass

func _on_animation_finished(anim_name: String):
	if anim_name == "slide_start":
		player.animation_player.play("sliding")
		play_slide = true
	if anim_name == "slide_end":
		get_parent().set_state("Idle")
