extends HBoxContainer

func _ready() -> void:
	var baseLavels = get_tree().get_nodes_in_group("base_level")

	if baseLavels.size() > 0:
		baseLavels[0].connect("coin_total_changed", self, "on_coin_total_changed")
		update_display(baseLavels[0].totalCoins, baseLavels[0].collectedCoins)


func update_display(total_coins: int, collectedCoins: int):
	$CoinLabel.text = str(collectedCoins, "/", total_coins)
	

func on_coin_total_changed(total_coins: int, collectedCoins: int):
	update_display(collectedCoins, total_coins)
