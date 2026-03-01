extends Node


# Declare variabel buat spawnpoint
var player_scene = preload("res://scenes/player/Player.tscn")
var player
var current_spawn : PlayerSpawn
var current_score: int = 0

# nyimpen parent nya player biar ga salah respawn
var spawn_parent

# buat ngetes autoload
func test():
	print("this is from auto load")

# fungsi buat spawn/respawn player
func player_spawn(parent):
	# debug apakah player scene ada
	if player_scene == null:
		print("Player scene belum di assign di GameManager!")
		return
	# ngeset biar player lama dihapus, biar ga double nanti
	if player:
		player.queue_free()
	# remember parent for respawns
	spawn_parent = parent  
	print("player parent are: ", spawn_parent)
	# spawn player lagi
	player = player_scene.instance()
	parent.add_child(player)
	# nyamain posisi spawn player sama posisi player spawn
	if current_spawn:
		player.global_position = current_spawn.global_position
	print("player instance:", player)

# fungsi buat player mati
func player_died():
	print("dead fuction active")
	print("the spawn parent when die are: ", spawn_parent)
	player_spawn(spawn_parent)  # reuse the stored parent
	
func add_score(amount: int):
	current_score += amount
	print("score :", current_score)
	GameState.coins = current_score
	emit_signal("score_updated", current_score) # Emit signal to update UI
