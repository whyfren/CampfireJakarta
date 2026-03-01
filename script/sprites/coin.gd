extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name == "Player":
		GameManager.add_score(1)
		AudioManager.play_sfx("coin")
		queue_free()
