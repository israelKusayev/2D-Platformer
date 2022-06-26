extends CanvasLayer

onready var playButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/PlayButton
onready var optionButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionButton
onready var quitButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton


func _ready() -> void:
	playButton.connect("pressed", self, "on_play_pressed")
	quitButton.connect("pressed", self, "on_quit_pressed")
	optionButton.connect("pressed", self, "on_options_pressed")


func on_play_pressed():
	$"/root/LevelManager".change_level(0)


func on_quit_pressed():
	get_tree().quit()


func on_options_pressed():
	$"/root/ScreenTransitionManager".transition_to_scene(
		"res://scenes/UI/OptionsMenuStandalone.tscn"
	)
