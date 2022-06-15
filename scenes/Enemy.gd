extends KinematicBody2D

var enemyDeathScene = preload("res://scenes/EnemyDeath.tscn")


export var isSpawning := true
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
	if isSpawning:
		return
	velocity.x = (direction * maxSpeed).x

	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

	$Visuals/AnimatedSprite.flip_h = true if direction.x > 0 else false

func kill():
	var deathInstance: Node2D = enemyDeathScene.instance()
	get_parent().add_child(deathInstance)
	deathInstance.global_position = global_position
	if velocity.x > 0:
		deathInstance.scale = Vector2(-1, 1)
	queue_free()


func on_goal_entered(_area2d) -> void:
	direction *= -1


func on_hitbox_entered(_area2d) -> void:
	$"/root/Helpers".apply_camera_shake(1)
	call_deferred("kill")
