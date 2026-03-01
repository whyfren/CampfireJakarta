extends Camera2D

# Zoom settings
export var zoom_min = Vector2(0.5, 0.5)  # Maximum zoom in
export var zoom_max = Vector2(3.0, 3.0)  # Maximum zoom out
export var zoom_speed = 0.1
export var zoom_step = 0.2

# Pan settings
export var pan_enabled = true
export var pan_speed = 500.0
export var pan_max_distance = 300.0  # Max distance from player
export var pan_return_speed = 5.0  # How fast camera returns to player

# Smooth zoom
export var smooth_zoom = true
export var zoom_lerp_speed = 8.0

# Internal variables
var target_zoom = Vector2(1.0, 1.0)
var pan_offset = Vector2.ZERO
var base_position = Vector2.ZERO

func _ready():
	# Set initial zoom
	target_zoom = zoom
	# Enable processing
	set_process(true)

func _process(delta):
	# Handle zoom input
	_handle_zoom_input(delta)
	
	# Handle panning input
	if pan_enabled:
		_handle_pan_input(delta)
	
	# Apply smooth zoom
	if smooth_zoom:
		zoom = zoom.linear_interpolate(target_zoom, zoom_lerp_speed * delta)
	else:
		zoom = target_zoom
	
	# Apply pan offset with smoothing
	offset = offset.linear_interpolate(pan_offset, pan_return_speed * delta)

func _handle_zoom_input(delta):
	var zoom_change = 0.0
	
	# Mouse wheel zoom
	if Input.is_action_just_pressed("ui_page_up") or Input.is_action_just_pressed("zoom_in"):
		zoom_change = -zoom_step
	elif Input.is_action_just_pressed("ui_page_down") or Input.is_action_just_pressed("zoom_out"):
		zoom_change = zoom_step
	
	# Alternative: Hold keys for continuous zoom
	if Input.is_action_pressed("zoom_in_hold"):
		zoom_change = -zoom_speed * delta
	elif Input.is_action_pressed("zoom_out_hold"):
		zoom_change = zoom_speed * delta
	
	# Apply zoom change
	if zoom_change != 0:
		target_zoom += Vector2(zoom_change, zoom_change)
		target_zoom.x = clamp(target_zoom.x, zoom_min.x, zoom_max.x)
		target_zoom.y = clamp(target_zoom.y, zoom_min.y, zoom_max.y)

func _handle_pan_input(delta):
	var pan_input = Vector2.ZERO
	
	# Get pan input (using arrow keys or WASD while holding a modifier)
	if Input.is_action_pressed("pan_modifier"):  # e.g., holding Shift
		if Input.is_action_pressed("ui_right"):
			pan_input.x += 1
		if Input.is_action_pressed("ui_left"):
			pan_input.x -= 1
		if Input.is_action_pressed("ui_down"):
			pan_input.y += 1
		if Input.is_action_pressed("ui_up"):
			pan_input.y -= 1
	
	# Apply panning
	if pan_input != Vector2.ZERO:
		pan_offset += pan_input.normalized() * pan_speed * delta
		
		# Clamp pan distance
		if pan_offset.length() > pan_max_distance:
			pan_offset = pan_offset.normalized() * pan_max_distance
	else:
		# Gradually return to center when not panning
		pan_offset = pan_offset.linear_interpolate(Vector2.ZERO, pan_return_speed * delta)

# Helper function to shake the camera (bonus feature!)
func shake(intensity = 10.0, duration = 0.3):
	var shake_timer = Timer.new()
	add_child(shake_timer)
	shake_timer.wait_time = duration
	shake_timer.one_shot = true
	shake_timer.start()
	
	var initial_offset = offset
	while shake_timer.time_left > 0:
		offset = initial_offset + Vector2(
			rand_range(-intensity, intensity),
			rand_range(-intensity, intensity)
		)
		yield(get_tree(), "idle_frame")
	
	offset = initial_offset
	shake_timer.queue_free()

# Reset camera to default state
func reset_camera():
	target_zoom = Vector2(1.0, 1.0)
	pan_offset = Vector2.ZERO
	offset = Vector2.ZERO

# Smoothly zoom to a specific level
func zoom_to(new_zoom: Vector2, instant = false):
	target_zoom = new_zoom
	target_zoom.x = clamp(target_zoom.x, zoom_min.x, zoom_max.x)
	target_zoom.y = clamp(target_zoom.y, zoom_min.y, zoom_max.y)
	
	if instant:
		zoom = target_zoom
