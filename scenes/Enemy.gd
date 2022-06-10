extends KinematicBody2D

var maxSpeed := 25
var velocity := Vector2.ZERO
var direction := Vector2.ZERO
var gravity := 500
var startDirection := Vector2.RIGHT

func _ready() -> void:
	direction = startDirection

	$GoalDetector.connect("area_entered", self, "on_goal_entered")
	$HitboxArea.connect("area_entered", self, "on_hitbox_entered")


func _process(delta: float) -> void:
	velocity.x = (direction * maxSpeed).x

	velocity.y += gravity * delta

	velocity = move_and_slide(velocity, Vector2.UP)

	$AnimatedSprite.flip_h = true if direction.x > 0 else false


func on_goal_entered(_area2d) -> void:
	direction *= -1

func on_hitbox_entered(_area2d) -> void:
	queue_free()
