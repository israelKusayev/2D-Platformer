extends Node2D

class_name BaseLevel

signal coin_total_changed

export(PackedScene) var levelCompleteScene

var playerScene = preload("res://scenes/Player.tscn")
var spwanPosition := Vector2.ZERO
var currentPlayerNode: Player = null
var totalCoins := 0
var collectedCoins := 0

func _ready() -> void:
	$Flag.connect("player_won", self, "on_player_won")
	spwanPosition = ($Player as Player).global_position
	register_player($Player as Player)
	
	coin_total_chaanged(get_tree().get_nodes_in_group("coin").size())

func coin_collected():
	collectedCoins += 1
	emit_signal("coin_total_changed", totalCoins, collectedCoins)

func coin_total_chaanged(newTotal):
	totalCoins = newTotal
	emit_signal("coin_total_changed", totalCoins, collectedCoins)
	
func register_player(player: Player):
	currentPlayerNode = player
	currentPlayerNode.connect("died", self, "on_player_died", [], CONNECT_DEFERRED)


func create_player():
	var playerInstance: Player = playerScene.instance()
	add_child_below_node(currentPlayerNode, playerInstance)
	playerInstance.global_position = spwanPosition
	register_player(playerInstance)


func on_player_died():
	currentPlayerNode.queue_free()
	create_player()

func on_player_won():
	currentPlayerNode.queue_free()
	var levelComplete = levelCompleteScene.instance()
	add_child(levelComplete)

