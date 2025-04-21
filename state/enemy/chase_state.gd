extends Node

@export var detection_radius: float = 10.0
@onready var animation_player: AnimationPlayer = %AnimationPlayer
var player: CharacterBody3D = null
@export var enemy: CharacterBody3D
@onready var nav_agent: NavigationAgent3D = %NavigationAgent3D
var SPEED = 5.0


func enter_state():
	player = get_parent().player
	animation_player.play("running")

func update_state(delta):
	if player and enemy.global_position.distance_to(player.global_position) < 15:
		# print("Distance to player: ", enemy.global_position.distance_to(player.global_position))
		enemy.velocity = Vector3.ZERO
		nav_agent.set_target_position(player.global_position)
		var next_nav_point = nav_agent.get_next_path_position()
		enemy.velocity = (next_nav_point - enemy.global_transform.origin).normalized() * SPEED
		enemy.look_at(Vector3(player.global_position.x, player.global_position.y, player.global_position.z), Vector3.UP)
		enemy.move_and_slide()
		if get_distance_to_player() < 2:
			get_parent().set_state("Attack")
	else:
		get_parent().set_state("Idle")
func exit_state():
	print("Exiting Chase State")
	animation_player.play("idle")
	# get_parent().set_state("Idle")

func get_distance_to_player():
	return enemy.global_position.distance_to(player.global_position)
