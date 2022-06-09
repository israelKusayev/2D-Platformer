extends Node2D

class_name Coin


func _ready() -> void:
	$Area2D.connect("area_entered", self, "on_area_entered")


func on_area_entered(_area2d):
	$AnimationPlayer.play("pickup")
	call_deferred("disable_pickup")
	
	var baseLevel: BaseLevel = get_tree().get_nodes_in_group("base_level")[0]
	baseLevel.coin_collected()


func disable_pickup():
	$Area2D/CollisionShape2D.disabled = true
