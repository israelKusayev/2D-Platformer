extends CanvasLayer


func _ready() -> void:
	var baseLavels = get_tree().get_nodes_in_group("base_level")

	if baseLavels.size() > 0:
		baseLavels[0].connect("coin_total_changed", self, "on_coin_total_changed")


func on_coin_total_changed(total_coins: int, collectedCoins: int):
	$MarginContainer/HBoxContainer/CoinLabel.text = str(collectedCoins, "/", total_coins)
