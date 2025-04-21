extends Node3D


@export var hit_points: int = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("bullet"):
		hit_points -= 1
		print("bullet hit tree")
		if hit_points <= 0:
			queue_free()
