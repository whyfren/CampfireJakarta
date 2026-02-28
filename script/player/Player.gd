extends KinematicBody2D

# ==============================
# NORMAL MOVEMENT SETTINGS
# ==============================
export var speed = 200
export var run_multiplier = 1.8
export var gravity = 1000
export var jump_force = -450

# ==============================
# SWIMMING SETTINGS
# ==============================
export var swim_speed = 150
export var swim_fast_multiplier = 1.7

# oxigen
var oxygen := 100.0
var oxygen_drain_rate := 10.0

# movement veriable
var velocity = Vector2.ZERO
var is_in_water = false
var facing_right = true
var is_running = false

# ==============================
# INVENTORY
# ==============================
var inventory = []


# ==============================
# PHYSICS PROCESS
# ==============================
func _physics_process(delta):

	if is_in_water:
		swim_movement()
		# drain oksigen
		if is_running:
			oxygen -= (oxygen_drain_rate * 2) * delta
		else:
			oxygen -= oxygen_drain_rate * delta
		print("oxygen : ", oxygen)
		# oksigen habis = mati
		if oxygen <= 0:
			oxygen = 0
			GameManager.player_died()
	else:
		normal_movement(delta)
		# regen oksigen
		print("oxygen : ", oxygen)
		oxygen = min(oxygen + 20 * delta, 100)

	velocity = move_and_slide(velocity, Vector2.UP)
	handle_animation()


# ==============================
# NORMAL MOVEMENT (WALK & RUN)
# ==============================
func normal_movement(delta):

	velocity.y += gravity * delta

	var direction = 0

	if Input.is_action_pressed("maju"):
		direction += 1
	if Input.is_action_pressed("mundur"):
		direction -= 1

	var current_speed = speed

	# RUN
	if Input.is_action_pressed("lari") and direction != 0:
		current_speed *= run_multiplier
		var is_running = true
	else:
		var is_running = false

	velocity.x = direction * current_speed

	if direction != 0:
		facing_right = direction > 0

	# JUMP
	if is_on_floor() and Input.is_action_just_pressed("lompat"):
		velocity.y = jump_force


# ==============================
# SWIMMING MOVEMENT
# ==============================
func swim_movement():

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

	var current_speed = swim_speed

	# SWIM FASTER (lari di air)
	if Input.is_action_pressed("lari") and (x_dir != 0 or y_dir != 0):
		current_speed *= swim_fast_multiplier
		var is_running = true
	else:
		var is_running = false

	velocity.x = x_dir * current_speed
	velocity.y = y_dir * current_speed

	if x_dir != 0:
		facing_right = x_dir > 0


# ==============================
# ANIMATION HANDLER
# ==============================
func handle_animation():

	$AnimatedSprite.flip_h = not facing_right

	# ==========================
	# SWIMMING MODE
	# ==========================
	if is_in_water:

		# TURUN
		if velocity.y > 0:
			if $AnimatedSprite.animation != "bawah":
				$AnimatedSprite.play("bawah")
			return

		# BERGERAK
		if velocity.x != 0 or velocity.y < 0:

			# Swim Faster
			if Input.is_action_pressed("lari"):
				if $AnimatedSprite.animation != "swim_faster":
					$AnimatedSprite.play("swim_faster")
			else:
				if $AnimatedSprite.animation != "swiming":
					$AnimatedSprite.play("swiming")
			return

		# IDLE DI AIR
		if $AnimatedSprite.animation != "swim":
			$AnimatedSprite.play("swim")
		return


	# ==========================
	# NORMAL MODE
	# ==========================
	if not is_on_floor():
		if $AnimatedSprite.animation != "jump":
			$AnimatedSprite.play("jump")
		return

	if velocity.x != 0:
		if Input.is_action_pressed("lari"):
			if $AnimatedSprite.animation != "running":
				$AnimatedSprite.play("running")
		else:
			if $AnimatedSprite.animation != "walking":
				$AnimatedSprite.play("walking")
		return

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


# ==============================
# INVENTORY SYSTEM
# ==============================
func add_item(item_name):
	inventory.append(item_name)
	print("Inventory:", inventory)
