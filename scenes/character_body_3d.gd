extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

func _physics_process(delta: float) -> void:
    # Add the gravity.
    if not is_on_floor():
        velocity += get_gravity() * delta

    # Handle jump.
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    # Get the input direction and handle the movement/deceleration.
    var input_dir := Input.get_vector("ui_up", "ui_down", "ui_right", "ui_left")
    if input_dir != Vector2.ZERO:
        # Adjust input direction for isometric camera
        var isometric_dir := Vector3(
            input_dir.x - input_dir.y, # Combine x and y for isometric movement
            0,
            input_dir.x + input_dir.y # Combine x and y for isometric movement
        ).normalized()
        velocity.x = isometric_dir.x * SPEED
        velocity.z = isometric_dir.z * SPEED
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)

    move_and_slide()