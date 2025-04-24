extends Node3D

@onready var health_bar: ProgressBar = $Sprite3D/SubViewport/HealthBar
@export var hit_points: int = 4
@onready var health_bar_timer: Timer = $HealthBarTimer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.visible = false
	health_bar_timer.timeout.connect(_on_health_bar_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("bullet"):
		health_bar.visible = true
		health_bar_timer.start()
		hit_points -= 1
		health_bar.value -= 25
		print("bullet hit tree")
		if hit_points <= 0:
			queue_free()

func _on_health_bar_timer_timeout() -> void:
	health_bar.visible = false
