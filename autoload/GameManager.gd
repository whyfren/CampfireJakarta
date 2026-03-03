extends Node

const WIN_SCORE = 13

var player_scene = preload("res://scenes/player/Player.tscn")
var player
var current_spawn : PlayerSpawn
var current_score: int = 0
var spawn_parent
var pause_menu

signal score_updated(new_score)

func test():
	print("this is from auto load")

func player_spawn(parent):
	if player_scene == null:
		print("Player scene belum di assign di GameManager!")
		return
	
	if player and is_instance_valid(player):
		player.queue_free()
	
	player = null
	spawn_parent = parent
	
	player = player_scene.instance()
	parent.add_child(player)
	
	if current_spawn:
		player.global_position = current_spawn.global_position
	
	print("player spawned:", player)

func player_died():
	print("dead function active")
	if spawn_parent and is_instance_valid(spawn_parent):
		player_spawn(spawn_parent)
	else:
		print("ERROR: spawn_parent sudah tidak valid!")

func add_score(amount: int):
	current_score += amount
	print("score:", current_score)
	GameState.coins = current_score
	emit_signal("score_updated", current_score)
	
	# Cek win condition
	if current_score >= WIN_SCORE:
		_trigger_win()

func _trigger_win():
	print("WIN! Score mencapai", current_score)
	get_tree().paused = false
	reset()
	get_tree().change_scene("res://scenes/UI/WinMenu.tscn")  # Sesuaikan path

func reset():
	player = null
	spawn_parent = null
	current_score = 0
	current_spawn = null

func toggle_pause():
	if get_tree().paused:
		print("nyala")
		get_tree().paused = false
		pause_menu.hide()
	else:
		get_tree().paused = true
		print("mati")
		if pause_menu:
			pause_menu.show()
