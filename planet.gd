extends Node

class planet:
	var name; var core; var base; var foundation; var ground; var camera;


	func _init(planetName: string = "", planetCore: Vector = Vector2(0, 0), genWidth, genRadius, landFormArray, noiseParameters):
		name = planetName
		core = planetCore

		base = instanceBodyVec(genWidth, genRadius)

	
	# Instance Planet Vectors - Creates a array of vectors as a base for planet	
	func instanceBodyVec(width, radius, objectArray):
		var vec = PoolVector2Array()
		for x in range(0, width):
			
			var percent = x / width
			var angle = x / float(radius)


			var pointsV = []
			var pointsH = []
			var array

			x = radius * cos(angle) + cos(angle)
			var y = radius * sin(angle) + sin(angle)
			var t = 0
			
			#addCell(x, y, tileMapColor)
			vec.push_back(Vector2(x, y))

		# drawBodyLayer(vec)
		return vec

	func instancefoundationVec(vec, objectArray):
		for x in range(0, vec.size()):

			var percent = x / width
			var angle = x / float(radius)

			for f in objectArray:
				var length = f.length; 
				var location = f.location; 
				var v = int(abs(x) - abs((location * width) + f.start))
				var startValue = ((location * width) + f.start) / width
				var endValue = ((location * width) + f.end) / width

				if f.direction == "v":
					array = pointsV
				else:
					array = pointsH

				if startValue <= percent and endValue >= percent:
					array.push_back((f.minVecArray[f.iteration].y - f.minVecArray[0].y) * f.scale)
					tileMapColor = 1
					f.iteration += 1
			
			var dx = 0; var dy = 0;

			for p in pointsV:
				dy -= p * 2

			for p in pointsH:
				dx -= p * 2


			x = (radius + dy) * cos(angle) + cos(angle) + (dx * sin(angle))
			y = (radius + dy) * sin(angle) + sin(angle) + (dx * cos(angle))

			vec.push_back(Vector2(x, y))

		# drawBodyLayer(vec)
		return vec

	func generate(noise, vec, _width, height, mesh):

		var n = 0
		for i in vec:
			var vecX = i.x; var vecY = i.y;
			var currentNoise = noise[n]
			
			var angle = findAngle(vecX, vecY);

			var x = vecX + ((cos(angle) * currentNoise) * height)
			var y = vecY + ((sin(angle) * currentNoise) * height)
			#addCell(x, y, 0)
			# vec.set(vec[i].index(), Vector2(x * cellSize, y * cellSize))
			vec[n] = Vector2(x * cellSize, y * cellSize)
			n += 1
		#mesh.polygon = vec
		return vec

	func findAngle(x, y) -> float:
		var vec = Vector2(x, y).normalized()
		return vec.angle()

	# Completes Noise Array - Returns Array	
	func tweenNumberArray(array, tweenAmount):
		
		var el1Num = array.size() - tweenAmount
		var el1Val = array[el1Num]
		var el2Num = tweenAmount
		var el2Val = array[el2Num]

		var midPoint = (el1Val + el2Val) / 2

		#addCell(genRadius, 0, 2)
		#addCell(genRadius + (genHeight * midPoint), 0, 1)

		var change = (el1Val - midPoint) / (tweenAmount)
		var h1 = change + el1Val
		for i in range(el1Num,  array.size()):
			array[i] = h1
			h1 -= change

		var h2 = -change + midPoint
		for e in range(0, el2Num):
			array[e] = h2
			h2 -= change
		
		return array

		func caculateGradient(vec):
			var gradientPoints = PoolVector2Array()
			var gradient = []
			var colourPoints = PoolColorArray()
			var offSets = []
		
			var gradientObj = Gradient.new()
		
			for p in range(0, vec.size()):
				# var grad = (abs(vec[p].y) - abs(vec[p - 1].y) * sin((-(1 + p) / float(vec.size())) * (2 * PI)) + abs(vec[p].x) - abs(vec[p - 1].x) * cos((-(1 + p) / float(vec.size())) * (2 * PI)))
				# print(sqrt(((vec[p].x * vec[p].x) + (vec[p].y * vec[p].y)) / float((vec[p - 1].x * vec[p - 1].x) + (vec[p - 1].y * vec[p - 1].y))))
				# var grad = (sqrt(((vec[p].x * vec[p].x) + (vec[p].y * vec[p].y)) / float((vec[p - 1].x * vec[p - 1].x) + (vec[p - 1].y * vec[p - 1].y))) / float(1 / float(vec.size()) * (2 * PI)))
				
				var grad = (sqrt(((vec[p].x * vec[p].x) + (vec[p].y * vec[p].y)) / float((vec[p - 1].x * vec[p - 1].x) + (vec[p - 1].y * vec[p - 1].y))) / float((2 * PI) / float(vec.size())) - genRadius)
		
				# print(grad)
				gradientPoints.append(Vector2(vec[p].x, vec[p].y))
				gradient.push_back(grad)
				offSets.push_back(p)
			
			gradient = smooth(gradient, 0.95)
			#print(gradientObj)
			for g in range(0,  vec.size()):
				# colourPoints.push_back(g / vec.size())
				# offSets.push_back(Color(255 * abs(gradient[g] / gradient.max()), 0, 0, 1))
				# print(255 * abs(gradient[g]))
				gradientObj.add_point(g / float(vec.size()), Color((1 * abs(gradient[g])), 0, 0, 1)) 
				# gradientObj.add_point(g / vec.size(), Color(255 * abs(gradient[g] / gradient.max()), 0, 0, 1))
			
			# gradientObj.offsets = smooth(gradientObj.offsets, 0.2)
		
			$Gradient.set_points(gradientPoints)
			# print($Gradient.get_gradient())
			
			# gradientObj.set_offsets(colourPoints)
			# gradientObj.set_colors(offSets)
			
		
			$Gradient.set_gradient(gradientObj)
		
			return gradient
			# print(gradientObj.colors[50])

			func smooth(values, alpha):
				print(values.size())
				var weighted = average(values) * alpha;
				var smoothed = [];
				for i in range(0, values.size()):
			
					var prevIndex = i - 1
					var nextIndex = i + 1
			
					if prevIndex == -1: 
						prevIndex = values.size() - 1;
					elif nextIndex == values.size(): 
						nextIndex = 0;
			
					var curr = values[i];
					var prev = values[prevIndex];
					var next = values[nextIndex];
					var improved = average([weighted, prev, curr, next]);
					smoothed.push_back(improved);
			
				return smoothed;
			
			func average(data):
				var sum = 0;
				for v in data:
					sum += v
				
				var avg = sum / data.size();
				return avg;
			
			
			
			func populate(vec, grad, surfaces):
			
				var noise;
				
			
				for s in surfaces:
					noise = tweenNumberArray(noiseArrayGenerator(genWidth, s.noise[0], s.noise[1], s.noise[2]), 20);
					#print(noise)
					var surfaceArray = []
			
					for p in range(0 + (vec.size() * s.planetStart), vec.size() * s.planetEnd):
						# print(p)
						# print(abs(grad[p]))
						# print(s.gradStart, " ", s.gradEnd)
						# Fix ree
						if abs(grad[p]) > s.gradStart and abs(grad[p]) < s.gradEnd:
							# #print(, " ", cos(-1 / float(grad[p])))
							# var angleX = cos(-1 / float(grad[p]))
							# var angleY = sin(-1 / float(grad[p]))
							# var normal = -1 * float(grad[p])
							# var normalX = sqrt((normal * normal) - ()
							# print(abs(angleX) + abs(angleY))
							# for d in range(0, s.depth):	
							# 	addCell(vec[p].x + (d * angleY), vec[p].y + (d * angleX), 2)
			
							# var normal = -1 * float(grad[p])
							# var normalX = sqrt((normal * normal) - ()
							# print(abs(angleX) + abs(angleY))
							
							# var crossVec = Vector3(vec[p].x, vec[p].y, 0).cross(Vector3(0, 0, 1)).normalized()
							var crossVec = Vector2(vec[p].x, vec[p].y).normalized()
							# print(crossVec)
			
							# for d in range(0, s.depth * noise[p]):	
							# 	addCell(vec[p].x + (d * crossVec.x), vec[p].y + (d * crossVec.y), 2)
			
							# for d in range(0, s.depth * abs(noise[p])):	
							# 	addCell(vec[p].x - (d * crossVec.x), vec[p].y - (d * crossVec.y), 2)
							var depth = abs(noise[p])
							surfaceArray.append(Vector2(vec[p].x, vec[p].y))
							surfaceArray.append(Vector2(vec[p].x - (depth * crossVec.x), vec[p].y - (depth * crossVec.y)))
							
							
							addCell(vec[p].x, vec[p].y, 1)
					
					s.points(surfaceArray)
					print(s.pointsArray)
					#_draw().populateDraw()
