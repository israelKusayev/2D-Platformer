extends Node

var sceneTransitionScene = preload("res://scenes/UI/ScreenTransition.tscn")

func transition_to_scene(scenePath: String):
	var screenTranistion = sceneTransitionScene.instance()
	add_child(screenTranistion)
	
	yield(screenTranistion, "screen_covered")
	get_tree().change_scene(scenePath)
