extends KinematicBody2D

# ===== NORMAL MOVEMENT SETTINGS =====
export var speed = 400
export var gravity = 1000
export var jump_force = -450

# ===== SWIMMING SETTINGS =====
export var swim_speed = 200
export var swim_gravity = 200

var velocity = Vector2.ZERO
var coin_count = 0
var is_in_water = false
var facing_right = true


func _physics_process(delta):

	if is_in_water:
		swim_movement(delta)
	else:
		normal_movement(delta)

	velocity = move_and_slide(velocity, Vector2.UP)

	handle_animation()


# ==============================
# NORMAL MOVEMENT
# ==============================
func normal_movement(delta):

	velocity.y += gravity * delta

	var direction = 0

	if Input.is_action_pressed("maju"):
		direction += 1
	if Input.is_action_pressed("mundur"):
		direction -= 1

	velocity.x = direction * speed

	if direction != 0:
		facing_right = direction > 0

	if is_on_floor() and Input.is_action_just_pressed("lompat"):
		velocity.y = jump_force


# ==============================
# SWIMMING MOVEMENT
# ==============================
func swim_movement(delta):

	var x_dir = 0
	var y_dir = 0

	if Input.is_action_pressed("maju"):
		x_dir += 1
	if Input.is_action_pressed("mundur"):
		x_dir -= 1
	if Input.is_action_pressed("lompat"):
		y_dir -= 1
	if Input.is_action_pressed("bawah"):
		y_dir += 1

	velocity.x = x_dir * swim_speed
	velocity.y = y_dir * swim_speed

	if x_dir != 0:
		facing_right = x_dir > 0


# ==============================
# ANIMATION HANDLER
# ==============================
func handle_animation():

	$AnimatedSprite.flip_h = not facing_right

	if is_in_water:

		# ===== TURUN =====
		if velocity.y > 0:
			if $AnimatedSprite.animation != "bawah":
				$AnimatedSprite.play("bawah")

		# ===== BERGERAK HORIZONTAL =====
		elif velocity.x != 0:
			if $AnimatedSprite.animation != "swiming":
				$AnimatedSprite.play("swiming")

		# ===== IDLE / NAIK =====
		else:
			if $AnimatedSprite.animation != "swim":
				$AnimatedSprite.play("swim")

		return


	# ===== NORMAL MODE =====
	if not is_on_floor():
		if $AnimatedSprite.animation != "jump":
			$AnimatedSprite.play("jump")

	elif velocity.x != 0:
		if $AnimatedSprite.animation != "running":
			$AnimatedSprite.play("running")

	else:
		if $AnimatedSprite.animation != "idle":
			$AnimatedSprite.play("idle")


# ==============================
# WATER SIGNALS
# ==============================
func enter_water():
	is_in_water = true
	velocity = Vector2.ZERO
func exit_water():
	is_in_water = false



# COIN SYSTEM

func add_coin():
	coin_count += 1
	print("Coin:", coin_count)
