extends Node

var player_scene = preload("res://scenes/player/Player.tscn")
var player
var current_spawn : PlayerSpawn
var current_score: int = 0
var spawn_parent  # ← ini yang jadi masalah kalau tidak di-reset
var pause_menu

func test():
	print("this is from auto load")

func player_spawn(parent):
	if player_scene == null:
		print("Player scene belum di assign di GameManager!")
		return
	
	# Cek dulu apakah player lama masih valid
	if player and is_instance_valid(player):
		player.queue_free()
	
	player = null
	spawn_parent = parent  # update ke parent yang baru (World yang baru)
	
	player = player_scene.instance()
	parent.add_child(player)
	
	if current_spawn:
		player.global_position = current_spawn.global_position
	
	print("player spawned:", player)

func player_died():
	print("dead function active")
	# Pastikan spawn_parent masih valid sebelum respawn
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
	if current_score >= 10:
		_trigger_win()

func _trigger_win():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/UI/WinMenu.tscn")  # Sesuaikan path
	reset()

# ← TAMBAHKAN INI: reset state saat scene berganti
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
