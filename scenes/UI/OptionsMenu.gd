extends CanvasLayer

class_name OptionsMenu

signal back_pressed

onready var backButton := $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/BackButton
onready var windowModeButton := $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/WindowModeButton
onready var musicRangeControl := $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/MusicVolumeContainer/RangeControl
onready var sfxRangeControl := $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/SFXVolumeContainer/RangeControl

var fullscreen := false

func _ready() -> void:
	windowModeButton.connect("pressed", self, "on_winodw_mode_pressed")
	backButton.connect("pressed", self, "on_back_pressed")
	musicRangeControl.connect("percentage_changed", self, "on_music_volume_changed")
	sfxRangeControl.connect("percentage_changed", self, "on_sfx_volume_changed")
	update_display()
	update_initial_volume_settings()

func on_music_volume_changed(percent: float):
	update_bus_volume("Music", percent)

func on_sfx_volume_changed(percent: float):
	update_bus_volume("SFX", percent)

func update_bus_volume(busName: String, volumePercent: float):
	var busIndex = AudioServer.get_bus_index(busName)
	var vloumeDb = linear2db(volumePercent)
	AudioServer.set_bus_volume_db(busIndex, vloumeDb)

func get_bus_volume_percent(busName: String):
	var busIndex = AudioServer.get_bus_index(busName)
	var volumePercent = db2linear(AudioServer.get_bus_volume_db(busIndex))
	return volumePercent

func update_initial_volume_settings():
	var musicPercent = get_bus_volume_percent("Music")
	musicRangeControl.set_current_percentage(musicPercent)
	
	var sfxPercent = get_bus_volume_percent("SFX")
	sfxRangeControl.set_current_percentage(sfxPercent)

func update_display():
	windowModeButton.text = "WINDOWED" if fullscreen else "FULLSCREEN"


func on_winodw_mode_pressed():
	fullscreen = !fullscreen
	OS.window_fullscreen = fullscreen
	update_display()


func on_back_pressed():
	emit_signal("back_pressed")
