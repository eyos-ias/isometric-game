extends Node

@export var enemy: CharacterBody3D
@export var detection_radius: float = 1.0

@onready var animation_player: AnimationPlayer = %AnimationPlayer
var player
func enter_state():
	#animation_player.animation_finished.connect(_on_animation_finished)
	player = get_parent().player
	animation_player.play("hurt")

func update_state(delta):
	pass
	#print("hurt state updating")

func exit_state():
	pass

func _on_animation_finished():
	get_parent().set_state("Idle")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_parent().set_state("Idle")
