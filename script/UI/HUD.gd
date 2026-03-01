extends CanvasLayer

onready var oxygen_bar = $Control/OxygenBar

func _physics_process(delta):
	var value = GameState.oxygen
	oxygen_bar.value = value

	var pct = value / GameState.max_oxygen
	if pct > 0.5:
		oxygen_bar.modulate = Color(0, 0.8, 1.0)
	elif pct > 0.25:
		oxygen_bar.modulate = Color(1.0, 0.6, 0.0)
	else:
		oxygen_bar.modulate = Color(1.0, 0.1, 0.1)
