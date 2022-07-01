extends Button

export(bool) var disableHoverAnim

func _ready() -> void:
	connect("mouse_entered", self, "on_mouse_entered")
	connect("mouse_exited", self, "on_mouse_exited")
	connect("focus_exited", self, "on_focus_exited")
	connect("pressed", self, "on_pressed")


func _process(delta: float) -> void:
	rect_pivot_offset = rect_min_size / 2


func on_mouse_entered():
	if !disableHoverAnim:
		$HoverAnimationPlayer.play("hover")


func on_mouse_exited():
	reset_button_state()

func on_focus_exited():
	reset_button_state()

func reset_button_state():
	if !disableHoverAnim:
		$HoverAnimationPlayer.play_backwards("hover")

func on_pressed():
	$ClickAnimationPlayer.play("click")
	$AudioStreamPlayer.play()
