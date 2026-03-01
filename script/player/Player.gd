extends KinematicBody2D

# ==============================
# NORMAL MOVEMENT
# ==============================
export var speed = 200
export var run_multiplier = 1.8
export var gravity = 1000
export var jump_force = -450

# ==============================
# SWIMMING
# ==============================
export var swim_speed = 150
export var swim_fast_multiplier = 1.7

# ==============================
# ATTACK
# ==============================
export var attack_duration = 0.2
export var attack_cooldown = 0.4

var velocity = Vector2.ZERO
var is_in_water = false
var facing_right = true
var is_attacking = false
var can_attack = true

# ==============================
# INVENTORY
# ==============================
var inventory = []


# ==============================
# PHYSICS PROCESS
# ==============================
func _physics_process(delta):

	handle_attack_input()

	if not is_attacking:
		if is_in_water:
			swim_movement()
		else:
<<<<<<< Updated upstream
			oxygen -= oxygen_drain_rate * delta
		print("oxygen : ", oxygen)
		GameState.oxygen = oxygen
		# oksigen habis = mati
		if oxygen <= 0:
			oxygen = 0
			GameManager.player_died()
	else:
		normal_movement(delta)
		# regen oksigen
		print("oxygen : ", oxygen)
		GameState.oxygen = oxygen
		oxygen = min(oxygen + 20 * delta, 100)
=======
			normal_movement(delta)
>>>>>>> Stashed changes

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

	var current_speed = speed

	if Input.is_action_pressed("lari") and direction != 0:
		current_speed *= run_multiplier

	velocity.x = direction * current_speed

	if direction != 0:
		facing_right = direction > 0

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

	if Input.is_action_pressed("lari") and (x_dir != 0 or y_dir != 0):
		current_speed *= swim_fast_multiplier

	velocity.x = x_dir * current_speed
	velocity.y = y_dir * current_speed

	if x_dir != 0:
		facing_right = x_dir > 0


# ==============================
# ATTACK SYSTEM (GODOT 3 STYLE)
# ==============================
func handle_attack_input():
	if Input.is_action_just_pressed("attack") and can_attack:
		start_attack()


func start_attack():
	is_attacking = true
	can_attack = false
	velocity = Vector2.ZERO

	$AnimatedSprite.play("attack")
	enable_hitbox()

	yield(get_tree().create_timer(attack_duration), "timeout")
	disable_hitbox()

	is_attacking = false

	yield(get_tree().create_timer(attack_cooldown), "timeout")
	can_attack = true


func enable_hitbox():
	$AttackArea.monitoring = true
	$AttackArea/CollisionShape2D.disabled = false


func disable_hitbox():
	$AttackArea.monitoring = false
	$AttackArea/CollisionShape2D.disabled = true


# ==============================
# ANIMATION SYSTEM
# ==============================
func handle_animation():

	$AnimatedSprite.flip_h = not facing_right

	# Geser hitbox sesuai arah
	if facing_right:
		$AttackArea.position.x = abs($AttackArea.position.x)
	else:
		$AttackArea.position.x = -abs($AttackArea.position.x)

	# ATTACK PRIORITY
	if is_attacking:
		return

	# ===== SWIM MODE =====
	if is_in_water:

		if velocity.y > 0:
			if $AnimatedSprite.animation != "bawah":
				$AnimatedSprite.play("bawah")
			return

		if velocity.x != 0 or velocity.y < 0:

			if Input.is_action_pressed("lari"):
				if $AnimatedSprite.animation != "swim_faster":
					$AnimatedSprite.play("swim_faster")
			else:
				if $AnimatedSprite.animation != "swiming":
					$AnimatedSprite.play("swiming")
			return

		if $AnimatedSprite.animation != "swim":
			$AnimatedSprite.play("swim")
		return


	# ===== LAND MODE =====
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
# INVENTORY
# ==============================
func add_item(item_name):
	inventory.append(item_name)
	print("Inventory:", inventory)


# ==============================
# ATTACK HIT DETECTION
# ==============================
func _on_AttackArea_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(1)
