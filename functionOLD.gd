extends Node


onready var tileMap = get_node("TileMap")
onready var line = get_node('Line2D')

var cellSize = 8
var o = 1

var _x = 0; var _X = 0; var _h = 0; var _k = 0; var _a = 0; var _c = 0; var _m = 0;

class landFormation:
	
	var power
	var startValue
	var endValue
	var gradient
	var horizontalShift
	var verticalShift
	
	func _init(start, end, function: int = 1, a: float = 1, h: float = 0, k: float = 0):
		power = function
		startValue = start
		endValue = end
		gradient = a
		horizontalShift = h
		verticalShift = k
		
class Vectors:
	
	var x
	var array
	
	func _init(X):
		x = X
		array = []
	
	func newPoint(y):
		array.push_back(y)

func _ready():
	
	### https://www.iquilezles.org/www/articles/smin/smin.htm ---- Smoothing Code
	#### FOR BETTER FUNCTION --- use min of all functions
	randomize()
	
	# var random1 = randf() * 0.2
	# var random2 = randf() * 10
	# var random3 = randf() * 10 - (randf() * 10)
	# var random4 = randf() * 0.2
	# var random5 = randf() * 0.0009
	# var random6 = randf() * 0.01
	
	var vectorArray = []
	var minVectorArray = []
	# var functionArray = [landFormation.new(-50, 50, 2, -0.2 + randf() * 0.2 , -20, -10), landFormation.new(-50, 50, 2, -0.2 + randf() * 0.2, 20, -10), landFormation.new(-50, 50, 2, -0.2 + randf() * 0.2, 20, -10), landFormation.new(-50, 10, 2, 0.0009 + randf() * 0.2, 30, -30)]
	var functionDomainStart = -100
	var functionDomainEnd = 100
	

	# var formation = landFormation.new(-50, 50, 2, -0.2 + randf() * 0.2 , -20, -10); functionArray.push_back(formation)
	# var formation2 = landFormation.new(-50, 50, 2, -0.2 + randf() * 0.2, 20, -10); functionArray.push_back(formation2)
	# #var formation3 = landFormation.new(-20 + random3, 20 + random3, 1, 0, 0, -10 - random2); functionArray.push_back(formation3)
	# var formation4 = landFormation.new(-50, 50, 2, -0.2 + randf() * 0.2, 20, -10); functionArray.push_back(formation4)
	# var formation5 = landFormation.new(-50, 10, 2, 0.0009 + randf() * 0.2, 30, -30); functionArray.push_back(formation5)

	""" 	
	var formation = landFormation.new(-50, 50, 2, -0.2 , -20, -10); functionArray.push_back(formation)
	var formation2 = landFormation.new(-50, 50, 2, -0.2, 20, -10); functionArray.push_back(formation2)
	var formation3 = landFormation.new(-20, 20, 1, 0, 0, -10); functionArray.push_back(formation3)
	var formation4 = landFormation.new(-10, 50, 2, 0.0009, -30, -30); functionArray.push_back(formation4)
	var formation5 = landFormation.new(-50, 10, 2, 0.0009, 30, -30); functionArray.push_back(formation5) 
	"""

#	var formation = landFormation.new(-20, 50, 3, 0.005 + random5, 20, -10); functionArray.push_back(formation)
#	var formation2 = landFormation.new(-50, 20, 3, -0.005 - random6, -20, -10); functionArray.push_back(formation2)
	
#	var formation = landFormation.new(-50, 50, 3, 0.005 + random5, 20, -10); functionArray.push_back(formation)
#	var formation2 = landFormation.new(-100, 50, 3, -0.005 - random6, -20, -10); functionArray.push_back(formation2)
#	var formation3 = landFormation.new(-20 + random3, 20 + random3, 1, 0, 0, -10 - random2); functionArray.push_back(formation3)
	
#	var formation4 = landFormation.new(-10, 50, 2, 0.0009 + random4, -30, -30); functionArray.push_back(formation4)
#	var formation5 = landFormation.new(-50, 10, 2, 0.0009 + random4, 30, -30); functionArray.push_back(formation5)
	
	for x in range(functionDomainStart, functionDomainEnd):
		var vecObj = Vectors.new(x)
		vectorArray.push_back(vecObj)
	
	for i in vectorArray:
		var x = i.x
		for f in functionArray:
			if (x >= f.startValue && x < f.endValue):
				var y = float(f.gradient) * float(power(x - f.horizontalShift, f.power)) + f.verticalShift
				i.newPoint(y)
				AddCell(i.x, y, 0)

	for i in vectorArray:
		var lowest = lowest(i)
		if lowest != null:
			AddCell(i.x, lowest, 1)
			minVectorArray.push_back(Vector2(i.x, lowest))
	
	var n = 0
	for i in minVectorArray:
		if n != minVectorArray.size():	
			n = 0
		else:
			n += 1

		var x = i.x; var y = i.y
		var smVector = hbSmooth(i, minVectorArray[n], 2)
		#var pmin = pmin(y, minVectorArray[n].y, 1)
		AddCell(smVector.x, smVector.y, 2)
		#line.add_point(Vector2(x * cellSize, pmin * cellSize))
		
	
#	print(pow(2, 256))

func smin(a:float, b:float, k:float):
	var  h = clamp( 0.5+0.5*(b-a)/k, 0.0, 1.0 );
	return h*a #k*h*(1.0-h);

func pmin(a:float, b:float, k:float):
	print(a)
	a = pow( a, k ); b = pow( b, k );
	return pow( (a*b)/(a+b), 1.0/k );
	print(pow((a*b)/(a+b), 1.0/k));

func hbSmooth(a:Vector2, b:Vector2, k:float):

	#var angle = 0
	#print(String(b.y) + ", " + String(a.y))
	#print((b.y - a.y))
	var angle = atan((b.y - a.y))
	var h = sin(angle) / k
	var cX = (b.x - a.x) + acos(h);	var cY = (b.y - a.y) + asin(h)

	return Vector2(-cX, -cY)


func lowest(i):
	var lowest
	for y in i.array:
			if lowest == null:
				lowest = y
			elif y > lowest:
				lowest = y
	return lowest

func power(x, power):
	if power == 0:
		if x < 0:
			return -1
		else:
			return 1
	else:
		var total = 1
		for _result in range(1, power + 1):
			total = total * float(x) 
		return total

func AddCell(x, y, cell):
	tileMap.set_cell(x, y, cell)	

func _on_Button_pressed():
	line.clear_points()
	tileMap.clear()
	_ready()
