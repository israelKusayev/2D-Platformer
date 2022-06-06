extends Node2D

var playerScene = preload("res://scenes/Player.tscn")
var spwanPosition = Vector2.ZERO
var currentPlayerNode: Player = null


func _ready() -> void:
	spwanPosition = ($Player as Player).global_position
	register_player($Player as Player)


func register_player(player: Player):
	currentPlayerNode = player
	currentPlayerNode.connect("died", self, "on_player_died", [], CONNECT_DEFERRED)


func create_player():
	var playerInstance = playerScene.instance()
	add_child_below_node(currentPlayerNode, playerInstance)
	playerInstance.global_position = spwanPosition
	register_player(playerInstance)


func on_player_died():
	currentPlayerNode.queue_free()
	create_player()
