extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name == "Player":
		AudioManager.play_sfx("coin")
		GameManager.add_score(1)
		queue_free()
