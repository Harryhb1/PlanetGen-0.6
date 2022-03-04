extends KinematicBody2D

onready var root = get_tree().get_root().get_node("root")
onready var tween = get_node("Tween")

export(float) var speed = 500
export(String) var stringPath = ""  
export(int) var bodyPosition = 0
var planetVec = []
var nearestPoint
var pointIndex
var time = 0

func _ready():
	planetVec = root.basePlanetVec
	pass

func move():
	planetVec = root.basePlanetVec
	
	# self.position = Vector2(planetVec[bodyPosition].x, planetVec[bodyPosition].y)
	tween.interpolate_property(self, "position",
		Vector2(self.position.x, self.position.y), Vector2(planetVec[bodyPosition].x, planetVec[bodyPosition].y), speed,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _process(delta):
	
	var moveDirection = newDirection(pointIndex)
	# print(moveDirection)

	if time > (1 / float(speed)) and bodyPosition != pointIndex:
		# bodyPosition += 1 * moveDirection
		if moveDirection == 1:
			bodyPosition += 1
		elif moveDirection == -1:
			bodyPosition -= 1
		elif bodyPosition == planetVec.size() - 1: 
			bodyPosition = 0
		elif bodyPosition == 0:
			bodyPosition = planetVec.size() - 1
		# if bodyPosition == planetVec.size() - 1: 
		# 	bodyPosition = 0
		# elif bodyPosition == 0:
		# 	bodyPosition = planetVec.size() - 1
		# else:
		# 	bodyPosition += 1 * moveDirection
		move()
		time = 0
	else:
		time += delta
	
func _input(event):
	if event.is_action_pressed("unit_move"):
		closesPoint(get_global_mouse_position().x, get_global_mouse_position().y)

func closesPoint(x, y):
	# print(x, " ", y)
	nearestPoint = planetVec[0]
	var pointIndexProgress = 0
	pointIndex = 0
	# look through spawn nodes to see if any are closer
	for point in planetVec:
		pointIndexProgress += 1
		if point.distance_to(Vector2(x, y)) < nearestPoint.distance_to(Vector2(x, y)):
			nearestPoint = point
			pointIndex = pointIndexProgress
	
	# print(pointIndex)
	


func newDirection(pointPosition):
	if pointIndex == null:
		return 0

	# print(bodyPosition - pointIndex)

	if bodyPosition - pointIndex <= 0:
		return 1
	
	elif bodyPosition - pointIndex > 0:
		return -1

	# if bodyPosition - pointIndex <= 0:
	# 	if bodyPosition - pointIndex <= PI:
	# 		return 1
	# 	elif bodyPosition - pointIndex > PI:
	# 		return -1
	
	# elif bodyPosition - pointIndex > 0:
	# 	if bodyPosition - pointIndex <= PI:
	# 		return -1
	# 	elif bodyPosition - pointIndex > PI:
	# 		return 1
	
