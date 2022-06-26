extends CanvasLayer

func _ready() -> void:
	$OptionsMenu.connect("back_pressed", self, "on_back_pressed")

func on_back_pressed():
	$"/root/ScreenTransitionManager".transition_to_main_menu()
