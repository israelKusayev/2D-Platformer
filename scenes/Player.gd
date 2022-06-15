extends KinematicBody2D

class_name Player

signal died

var playerDeathScene := preload("res://scenes/PlayerDeath.tscn")

enum State { NORMAL, DASHING }

export(int, LAYERS_2D_PHYSICS) var dashHazardMask

var gravity := 1000
var velocity := Vector2.ZERO
var maxHorizontalSpeed := 140
var maxDashSpeed := 500
var minDashSpeed := 200
var horizontalAcceleration := 2000
var jumpSpeed := 320
var jumpTerminationMultiplier := 4
var hasDoubleJump := false
var hasDash := false
var currentState = State.NORMAL
var isStateNew = true
var defaultHazardMask := 0
var isDying := false

func _ready() -> void:
	$HazardArea.connect("area_entered", self, "on_hazard_area_entered")
	defaultHazardMask = $HazardArea.collision_mask


func _process(delta: float) -> void:
	match currentState:
		State.NORMAL:
			process_normal(delta)
		State.DASHING:
			process_dash(delta)
	isStateNew = false


func change_state(new_state):
	currentState = new_state
	isStateNew = true


func process_normal(delta: float):
	if isStateNew:
		$DashArea/CollisionShape2D.disabled = true
		$HazardArea.collision_mask = defaultHazardMask

	var moveVector := get_movement_vector()

	velocity.x += moveVector.x * horizontalAcceleration * delta
	if moveVector.x == 0:
		velocity.x = lerp(velocity.x, 0, .1)
		velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))

	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)

	if moveVector.y < 0 && (is_on_floor() || !$CoyoteTimer.is_stopped() || hasDoubleJump):
		velocity.y = moveVector.y * jumpSpeed
		if !is_on_floor() && $CoyoteTimer.is_stopped():
			$"/root/Helpers".apply_camera_shake(.75)
			hasDoubleJump = false
		$CoyoteTimer.stop()

	if velocity.y < 0 && !Input.is_action_pressed("jump"):
		velocity.y += gravity * jumpTerminationMultiplier * delta
	else:
		velocity.y += gravity * delta

	var wasOnFloor = is_on_floor()

	velocity = move_and_slide(velocity, Vector2.UP)

	if wasOnFloor && !is_on_floor():
		$CoyoteTimer.start()

	if is_on_floor():
		hasDoubleJump = true
		hasDash = true

	if hasDash && Input.is_action_just_pressed("dash"):
		call_deferred("change_state", State.DASHING)
		hasDash = false

	update_animation()


func process_dash(delta: float):
	if isStateNew:
		$"/root/Helpers".apply_camera_shake(.75)
		$DashArea/CollisionShape2D.disabled = false
		$AnimatedSprite.play("jump")
		$HazardArea.collision_mask = dashHazardMask
		var moveVector := get_movement_vector()
		var velocityMod := 1.0
		if moveVector.x != 0:
			velocityMod = sign(moveVector.x)
		else:
			velocityMod = 1 if $AnimatedSprite.flip_h else -1

		velocity = Vector2(maxDashSpeed * velocityMod, 0)
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.x = lerp(0, velocity.x, pow(2, -8 * delta))

	if abs(velocity.x) < minDashSpeed:
		call_deferred("change_state", State.NORMAL)


func get_movement_vector() -> Vector2:
	var moveVector = Vector2.ZERO
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return moveVector


func update_animation():
	var moveVector := get_movement_vector()
	if !is_on_floor():
		$AnimatedSprite.play("jump")
	elif moveVector.x != 0:
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")

	if moveVector.x != 0:
		$AnimatedSprite.flip_h = true if moveVector.x > 0 else false


func kill():
	if isDying:
		return

	isDying = true
	var playerDeathInstance: PlayerDeath = playerDeathScene.instance()
	playerDeathInstance.velocity = velocity
	get_parent().add_child_below_node(self, playerDeathInstance)
	playerDeathInstance.global_position = global_position
	emit_signal("died")


func on_hazard_area_entered(_area2d):
	$"/root/Helpers".apply_camera_shake(1)
	call_deferred("kill")
