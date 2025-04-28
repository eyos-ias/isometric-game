extends Node3D
@export var enabled: bool = false
@export var speed: float = 13.0
@export var boomerand_range: float = 20.0
@export var player: Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fire: bool = false
@onready var return_to_player: bool = false

@export var parent: Node3D


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass

func throw_boomerang():
	if animation_player.current_animation != "inverse_rotate":
		animation_player.play("inverse_rotate")
	print("throw boomerang")
