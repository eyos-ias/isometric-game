extends Node3D
class_name Bullet
@export var SPEED = 40.0

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@export var enabled: bool = false

#signal give_stat(stat_type: int)
#signal enemy_hit(enemy)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotate_y(deg_to_rad(90))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += transform.basis * Vector3(0, 0, SPEED) * delta


func _on_timer_timeout() -> void:
	# print("queue freed")
	queue_free()


func _on_area_3d_area_entered(area: Area3D) -> void:
	print("i hit an area boss")
	
	queue_free()
	

#
#func _on_area_3d_body_entered(body: Node3D) -> void:
	#print("i hit something boss")
	#if (body.is_in_group("player")):
		#print("print player hit")
