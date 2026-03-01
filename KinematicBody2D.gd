extends KinematicBody2D

export var speed = 150.0
export var detection_radius = 300.0
export var attack_range = 40.0
export var health = 3

enum State { IDLE, CHASE, ATTACK }
var current_state = State.IDLE
var velocity = Vector2.ZERO
var player = null

func _ready():
	player = get_tree().get_root().find_node("Player", true, false)
	if player == null:
		push_warning("Enemy: Player node not found!")

func _physics_process(delta):
	if player == null:
		return
	var distance_to_player = position.distance_to(player.position)
	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO
			if distance_to_player < detection_radius:
				current_state = State.CHASE
		State.CHASE:
			if distance_to_player < attack_range:
				velocity = Vector2.ZERO
				current_state = State.ATTACK
			elif distance_to_player > detection_radius * 1.2:
				velocity = Vector2.ZERO
				current_state = State.IDLE
			else:
				_move_toward_player()
		State.ATTACK:
			velocity = Vector2.ZERO
			if distance_to_player > attack_range:
				current_state = State.CHASE
			else:
				_attack()
	move_and_slide(velocity)

func _move_toward_player():
	var direction = (player.position - position).normalized()
	velocity = direction * speed
	look_at(player.position)

func _attack():
	print("Enemy attacks!")

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func die():
	queue_free()
