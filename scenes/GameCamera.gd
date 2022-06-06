extends Camera2D

class_name GameCamera

var targetPosition = Vector2.ZERO

export(Color, RGB) var backgroundColor


func _ready() -> void:
	VisualServer.set_default_clear_color(backgroundColor)


func _process(delta: float) -> void:
	acuire_target_position()

	global_position = lerp(targetPosition, global_position, pow(2, -15 * delta))


func acuire_target_position():
	var players := get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var player = players[0]
		targetPosition = player.global_position
