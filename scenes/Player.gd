extends KinematicBody2D

signal died

var gravity: = 1000
var velocity: = Vector2.ZERO
var maxHorizontalSpeed: = 140
var horizontalAcceleration: = 2000
var jumpSpeed: = 360
var jumpTerminationMultiplier = 4
var hasDoubleJump = false

func _ready() -> void:
	$HazardArea.connect("area_entered", self, "on_hazard_area_entered")


func _process(delta: float) -> void:
	var moveVector = get_movment_vector()
	
	velocity.x += moveVector.x * horizontalAcceleration * delta
	if moveVector.x == 0:
		velocity.x = lerp(velocity.x, 0, .1)
		velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
		
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	if moveVector.y < 0 && (is_on_floor() || !$CoyoteTimer.is_stopped() || hasDoubleJump):
		velocity.y = moveVector.y * jumpSpeed
		if !is_on_floor() && $CoyoteTimer.is_stopped():
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
	
	update_animation()

func get_movment_vector() -> Vector2:
	var moveVector = Vector2.ZERO
	moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
	return moveVector


func update_animation():
	var moveVector = get_movment_vector()
	if !is_on_floor():
		$AnimatedSprite.play("jump")
	elif moveVector.x != 0: 
		$AnimatedSprite.play("run")
	else:
		$AnimatedSprite.play("idle")
		
	if moveVector.x != 0:
		$AnimatedSprite.flip_h = true if moveVector.x > 0 else false
		
		
func on_hazard_area_entered(area2d):
		emit_signal("died")
