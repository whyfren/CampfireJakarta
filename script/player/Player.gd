extends KinematicBody2D

export var speed = 400
export var gravity = 1000
export var jump_force = -400

var velocity = Vector2.ZERO
var UP = Vector2.UP # Arah atas untuk fungsi move_and_slide

func _ready():
	pass

func _physics_process(delta):
	# 1. Gravitasi
	velocity.y += gravity * delta

	# 2. Input Horizontal
	var direction = 0
	if Input.is_action_pressed("maju"):
		direction += 1
	if Input.is_action_pressed("mundur"):
		direction -= 1
	
	velocity.x = direction * speed

	# 3. Melompat
	if is_on_floor() and Input.is_action_just_pressed("lompat"):
		velocity.y = jump_force

	# 4. Pergerakan & Tabrakan (Penting: move_and_slide di Godot 3 butuh arah UP)
	velocity = move_and_slide(velocity, UP)
