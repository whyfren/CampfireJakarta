extends Node  # atau KinematicBody2D, Node2D, dll — sesuaikan dengan node World kamu

var pause_menu

func _ready():
	pause_menu = $PauseMenu  # $ artinya cari child node bernama "PauseMenu" di scene
	pause_menu.hide()
	GameManager.pause_menu = $PauseMenu

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	if get_tree().paused:
		print("nyala")
		get_tree().paused = false
		pause_menu.hide()
	else:
		get_tree().paused = true
		print("mati")
		pause_menu.show()
