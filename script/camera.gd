extends Camera2D

var velocity = Vector2(0, 0)
var moveSpeed = 100
var zoomSpeed = 5

func _process(delta):


	# position = get_global_mouse_position()

	
	if Input.is_action_pressed("camera_up"):
		velocity.y -= moveSpeed * delta
	elif Input.is_action_pressed("camera_down"):
		velocity.y += moveSpeed * delta
	else:
		velocity.y = lerp(velocity.y, 0, 1)
		
	if Input.is_action_pressed("camera_left"):
		velocity.x -= moveSpeed * delta
	elif Input.is_action_pressed("camera_right"):
		velocity.x += moveSpeed * delta
	else:
		velocity.x = lerp(velocity.x, 0, 1)
	
	if Input.is_action_pressed("camera_zoom_in"):
		zoom.x += zoomSpeed * delta
		zoom.y += zoomSpeed * delta
	elif Input.is_action_pressed("camera_zoom_out"):
		zoom.x -= zoomSpeed * delta
		zoom.y -= zoomSpeed * delta
	
	set_position(position + velocity)
