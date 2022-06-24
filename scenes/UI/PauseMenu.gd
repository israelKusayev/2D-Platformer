extends CanvasLayer

onready var coninueButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ContinueButton
onready var optionsButtom = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/OptionButton
onready var quitButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:
	coninueButton.connect("pressed", self, "on_continue_pressed")
	optionsButtom.connect("pressed", self, "on_options_pressed")
	quitButton.connect("pressed", self, "on_quit_pressed")
	get_tree().paused = true


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("pause"):
		get_tree().set_input_as_handled()
		unpause()

func unpause():
	queue_free()
	get_tree().paused = false

func on_continue_pressed():
	unpause()

func on_options_pressed():
	pass

func on_quit_pressed():
	$"/root/ScreenTransitionManager".transition_to_main_menu()
	unpause()
