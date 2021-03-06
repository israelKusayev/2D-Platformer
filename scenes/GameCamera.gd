extends Camera2D

class_name GameCamera

var targetPosition = Vector2.ZERO

export(Color, RGB) var backgroundColor
export(OpenSimplexNoise) var shakeNoise

var xNoiseSampleVector := Vector2.RIGHT
var yNoiseSampleVector := Vector2.DOWN
var xNoiseSamplePosition := Vector2.ZERO
var yNoiseSamplePosition := Vector2.ZERO
var noiseSampleTravelRate := 500
var maxShakeOffset := 10
var currentShakePrecentage := 0.0
var shakeDecay := 3


func _ready() -> void:
	VisualServer.set_default_clear_color(backgroundColor)


func _process(delta: float) -> void:
	acuire_target_position()

	global_position = lerp(targetPosition, global_position, pow(2, -15 * delta))

	if currentShakePrecentage > 0:
		xNoiseSamplePosition += xNoiseSampleVector * noiseSampleTravelRate * delta
		yNoiseSamplePosition += yNoiseSampleVector * noiseSampleTravelRate * delta
		var xSample = shakeNoise.get_noise_2d(xNoiseSamplePosition.x, xNoiseSamplePosition.y)
		var ySample = shakeNoise.get_noise_2d(yNoiseSamplePosition.x, yNoiseSamplePosition.y)

		var calculatedOffset = (
			Vector2(xSample, ySample)
			* maxShakeOffset
			* pow(currentShakePrecentage, 2)
		)
		offset = calculatedOffset

		currentShakePrecentage = clamp(currentShakePrecentage - shakeDecay, 0.0, 1.0)


func apply_shake(precentage: float):
	currentShakePrecentage = clamp(currentShakePrecentage + precentage, 0.0, 1.0)


func acuire_target_position():
	var acquired = get_target_position_from_node_group("player")
	if !acquired:
		get_target_position_from_node_group("player_death")


func get_target_position_from_node_group(groupName: String) -> bool:
	var players := get_tree().get_nodes_in_group(groupName)
	if players.size() > 0:
		var player = players[0]
		targetPosition = player.global_position
		return true
	return false
