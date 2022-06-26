extends CanvasLayer

class_name OptionsMenu

signal back_pressed

onready var backButton := $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BackButton
onready var windowModeButton := $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/WindowModeButton

var fullscreen := false


func _ready() -> void:
	windowModeButton.connect("pressed", self, "on_winodw_mode_pressed")
	backButton.connect("pressed", self, "on_back_pressed")
	update_display()


func update_display():
	windowModeButton.text = "WINDOWED" if fullscreen else "FULLSCREEN"


func on_winodw_mode_pressed():
	fullscreen = !fullscreen
	OS.window_fullscreen = fullscreen
	update_display()


func on_back_pressed():
	emit_signal("back_pressed")
