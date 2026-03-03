extends Control

func _ready():
	# Connect semua button
	$VBoxContainer/PlayButton.connect("pressed", self, "_on_PlayButton_pressed")
	$VBoxContainer/MenuButton.connect("pressed", self, "_on_MenuButton_pressed")
	$VBoxContainer/QuitButton.connect("pressed", self, "_on_QuitButton_pressed")
	
	# Connect hover signals
	$VBoxContainer/PlayButton.connect("mouse_entered", self, "_on_PlayButton_hover")
	$VBoxContainer/PlayButton.connect("mouse_exited", self, "_on_PlayButton_unhover")
	
	$VBoxContainer/MenuButton.connect("mouse_entered", self, "_on_MenuButton_hover")
	$VBoxContainer/MenuButton.connect("mouse_exited", self, "_on_MenuButton_unhover")
	
	$VBoxContainer/QuitButton.connect("mouse_entered", self, "_on_QuitButton_hover")
	$VBoxContainer/QuitButton.connect("mouse_exited", self, "_on_QuitButton_unhover")

# ─── BUTTON PRESSED ───────────────────────────────────────
func _on_PlayButton_pressed():
	print("Resume ditekan!")
	get_tree().paused = false
	hide()  # Sembunyikan pause menu

func _on_MenuButton_pressed():
	print("Menu ditekan!")
	get_tree().paused = false
	get_tree().change_scene("res://scenes/UI/MainMenu.tscn")  # Sesuaikan path

func _on_QuitButton_pressed():
	print("Quit ditekan!")
	get_tree().quit()

# ─── HOVER EFFECTS ────────────────────────────────────────
func _on_PlayButton_hover():
	_scale_up($VBoxContainer/PlayButton)
func _on_PlayButton_unhover():
	_scale_down($VBoxContainer/PlayButton)

func _on_MenuButton_hover():
	_scale_up($VBoxContainer/MenuButton)
func _on_MenuButton_unhover():
	_scale_down($VBoxContainer/MenuButton)

func _on_QuitButton_hover():
	_scale_up($VBoxContainer/QuitButton)
func _on_QuitButton_unhover():
	_scale_down($VBoxContainer/QuitButton)

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
