extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# manggil fungsi biar player spawn
	GameManager.player_spawn(self)
