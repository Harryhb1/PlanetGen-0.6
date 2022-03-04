extends Node

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

func genLandFormation(functionArray, start: int = -100, end: int = 100):
	randomize()
	
	var vectorArray = []
	var minVectorArray = []
	var functionDomainStart = start
	var functionDomainEnd = end
	
	
	for x in range(functionDomainStart, functionDomainEnd):
		var vecObj = Vectors.new(x)
		vectorArray.push_back(vecObj)
	
	for i in vectorArray:
		var x = i.x
		for f in functionArray:
			if (x >= f.startValue && x < f.endValue):
				var y = float(f.gradient) * float(power(x - f.horizontalShift, f.power)) + f.verticalShift
				i.newPoint(y)

	for i in vectorArray:
		var lowest = lowest(i)
		if lowest != null:
			minVectorArray.push_back(Vector2(i.x, lowest))

	return minVectorArray
			
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


func test():
	print("TEST")