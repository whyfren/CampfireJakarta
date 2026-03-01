extends Control

func _ready():
	$VBoxContainer/MainMenuButton.connect("pressed", self, "_on_MainMenuButton_pressed")
	$VBoxContainer/About.connect("pressed", self, "_on_About_pressed")
	
	$VBoxContainer/MainMenuButton.connect("mouse_entered", self, "_on_MainMenuButton_hover")
	$VBoxContainer/MainMenuButton.connect("mouse_exited", self, "_on_MainMenuButton_unhover")
	
	$VBoxContainer/About.connect("mouse_entered", self, "_on_About_hover")
	$VBoxContainer/About.connect("mouse_exited", self, "_on_About_unhover")


# ─── BUTTON PRESSED ───────────────────────────────────────
func _on_MainMenuButton_pressed():
	print("Play ditekan!")
	get_tree().change_scene("res://scenes/UI/MainMenu.tscn")

func _on_About_pressed():
	print("About ditekan!")
	get_tree().change_scene("res://scenes/About.tscn")


# ─── HOVER EFFECTS ────────────────────────────────────────
func _on_MainMenuButton_hover():
	_scale_up($VBoxContainer/MainMenuButton)

func _on_MainMenuButton_unhover():
	_scale_down($VBoxContainer/MainMenuButton)

func _on_About_hover():
	_scale_up($VBoxContainer/About)

func _on_About_unhover():
	_scale_down($VBoxContainer/About)


# ─── HELPER FUNCTIONS ─────────────────────────────────────
func _scale_up(button: Button):
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(
		button, "rect_scale",
		Vector2(1, 1), Vector2(1.1, 1.1),
		0.1, Tween.TRANS_SINE, Tween.EASE_OUT
	)
	tween.start()
	tween.connect("tween_all_completed", tween, "queue_free")

func _scale_down(button: Button):
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(
		button, "rect_scale",
		Vector2(1.1, 1.1), Vector2(1, 1),
		0.1, Tween.TRANS_SINE, Tween.EASE_IN
	)
	tween.start()
	tween.connect("tween_all_completed", tween, "queue_free")
