extends Node2D

# declare class name biar gampang dicar di GameManager.gd
class_name PlayerSpawn

# dclare current spawn biar pas respawn, player tetep diplayer spawn
func _ready():
	GameManager.current_spawn = self
