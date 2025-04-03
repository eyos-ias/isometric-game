extends CharacterBody3D

var player: CharacterBody3D = null
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@export var player_path: NodePath

func _ready():
	player = get_node(player_path)

func _process(delta: float) -> void:
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_position)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
	look_at(Vector3(player.global_position.x, global_position.y, global_position.y), Vector3.UP)
	
	move_and_slide()

func _physics_process(delta: float) -> void:
	pass
