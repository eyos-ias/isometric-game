extends Node

@export var enemy: CharacterBody3D
@export var detection_radius: float = 1.0

@onready var animation_player: AnimationPlayer = %AnimationPlayer
var player
func enter_state():
	player = get_parent().player
	animation_player.play("idle")
	print("Enemy is idle")

func update_state(delta):
	# print("Player: ", player)
	if player:
		print("Distance to player: ", enemy.global_position.distance_to(player.global_position))
	if player and enemy.global_position.distance_to(player.global_position) < detection_radius:
		enemy.look_at(Vector3(player.global_position.x, player.global_position.y, player.global_position.z), Vector3.UP)
		print("should chase")
		get_parent().set_state("Chase")

func exit_state():
	print("Exiting Idle State")
