extends Node2D

# Imports
# onready var functionFile = preload("Functions/function.gd")
# onready var function = functionFile.new()
onready var functions = load("Data/importData.gd")

# Planet Base
export var genRadius = 200
export var genHeight = 20

export var tweenDistance = 10
var cellSize = 2

var genWidth = 2 * PI * genRadius

var basePlanetVec = []
var landFormArray = []
var gradientVec = []
var surfaces = []
var surfacesFlat = []

# Nodes
onready var bodyMesh = get_node("Polygon2D")
onready var tileMap = get_node("TileMap")
onready var body = get_node("body")

onready var grass = load("res://Assets/grass.tscn")

############################# Vector Object #############################
class bodyVector:

	var x; var y; var angle; var smoothFactor

	func _init(xx: float, yy: float, smFactor: float = 1):
		x = xx
		y = yy
		smoothFactor = smFactor

######################### Land Formation Object #########################



############################# Planet Object ############################

	# func _init(planetName: string = "", planetCore: Vector = Vector2(0, 0), baseVec: array, foundationVec: array, groundVec: array, cameraVec; array):
	# 	name = planetName
	# 	core = planetCore
	# 	base = baseVec
	# 	foundation = foundationVec
	# 	ground = groundVec
	# 	camera = cameraVec
			
	
# Ready Function - Runs on Load
func _ready() -> void:
	var functionsJSON = LoadFileData("res://Data/function.json")
	var surfacesJSON = LoadFileData("res://Data/surface.json")
	# surfaces = [surface.new(surfacesJSON["grass"])]
	# print(surfacesJSON["grass"]["name"])
	# print(functionsJSON["cliffs"]["cliff1"]["functions"])
	# landFormArray = [landFormationInstance.new(functionsJSON["cliffs"]["cliff1"], 0.5)]
	# landFormArray = [landFormationInstance.new(functionsJSON["crators"]["crator1"], 0.5), landFormationInstance.new(functionsJSON["mountains"]["mount3"], 0.2), landFormationInstance.new(functionsJSON["mountains"]["mount2"], 0.7)]
	#addLandFormToArray()
	print(functionsJSON)
	
	"""
	planet.new()
	var bodyVec = instanceBodyVec(genWidth, genRadius, landFormArray)
	# basePlanetVec = bodyVec
	var noiseArray = tweenNumberArray(noiseArrayGenerator(genWidth, 1, 90, 0.3), 20);
	# var noiseArray = noiseArrayGenerator(genWidth, 1, 90, 0.3);
	basePlanetVec = generate(noiseArray, bodyVec, genWidth, genHeight, bodyMesh)
	gradientVec = caculateGradient(basePlanetVec)
	populate(basePlanetVec, gradientVec, surfaces)

	# get_node("unit").move() 
	"""


func openJSON(path):
	var data_file = File.new()
	if data_file.open(path, File.READ) != OK:
		return
	var data_text = data_file.get_as_text()
	data_file.close()
	var data_parse = JSON.parse(data_text)
	if data_parse.error != OK:
		return
	return data_parse.result

func _on_gen_pressed() -> void:
	tileMap.clear()
	var _bodyVec = PoolVector2Array(); _ready()

func addCell(x, y, cell) -> void:
	tileMap.set_cell(x, y, cell)

func _draw():
	# var white = Color(255, 255, 255, 1)
	# var array = [white]
	var colors = PoolColorArray(["FFFFFF"])
	# var colors = ColorArray([Color("FFFFFF")])
	# basePlanetVec.remove(1ss)
	var vec = basePlanetVec

	draw_polygon(basePlanetVec, colors, PoolVector2Array(), null, null, true)

	for s in surfaces:
		# convert color
		#draw_primitive(s.pointsArray, PoolColorArray(["96d49e"]), PoolVector2Array())

		draw_polygon(s.pointsArray, PoolColorArray(["96d49e"]), PoolVector2Array(), null, null, true)

	pass


func _process(delta):
	update()

func LoadFileData(FilePath):
	var DataFile = File.new()
	var DataJSon
	DataFile.open(FilePath, File.READ)
	DataJSon = JSON.parse(DataFile.get_as_text())
	DataFile.close()
	return DataJSon.result

