extends Node

@export var enemy: CharacterBody3D
@export var detection_radius: float = 1.0

@onready var animation_player: AnimationPlayer = %AnimationPlayer
var player


func enter_state():
	#animation_player.animation_finished.connect(_on_animation_finished)
	player = get_parent().player
	animation_player.play("attack")
	print("entering attack state")

func update_state(delta):
	if get_distance_to_player() > 3:
		get_parent().set_state("Chase")
	else:
		if(animation_player.current_animation != "attack"):
			animation_player.play("attack")
		print("attacking")

func exit_state():
	animation_player.play("attack")
	print("Exiting Idle State")

func get_distance_to_player():
	return enemy.global_position.distance_to(player.global_position)

func _on_animation_finished():
	print("animation finished")
	animation_player.play("attack")
