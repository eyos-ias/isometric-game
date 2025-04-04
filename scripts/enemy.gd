extends CharacterBody3D
#@onready var state_machine: Node = $StateMachine
#var player: CharacterBody3D = null
#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
#@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
#@export var player_path: NodePath
#@onready var animation_player: AnimationPlayer = $monkey/AnimationPlayer
#@onready var idle: Node = $StateMachine/Idle
#func _ready():
	#pass
#
	#
	#
#func _process(delta: float) -> void:
	#velocity = Vector3.ZERO
	#nav_agent.set_target_position(player.global_position)
	#var next_nav_point = nav_agent.get_next_path_position()
	#velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
#
	#look_at(Vector3(player.global_position.x, player.global_position.y, player.global_position.z), Vector3.UP)
#
	#move_and_slide()

 #func _physics_process(delta: float) -> void:
 	#pass
