extends KinematicBody2D

class_name PlayerDeath

var velocity := Vector2.ZERO
var gravity := 1000

func _process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

	if is_on_floor():
		velocity.x = lerp(0, velocity.x, pow(2, -1 * delta))
