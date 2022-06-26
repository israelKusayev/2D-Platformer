extends CanvasLayer

onready var continueButton := $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ContinueButton


func _ready() -> void:
	continueButton.connect("pressed", self, "on_continue_pressed")


func on_continue_pressed():
	$"/root/ScreenTransitionManager".transition_to_main_menu()
