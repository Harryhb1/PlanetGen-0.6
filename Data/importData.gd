extends Node

var functions

func _ready():
	functions = LoadFileData("res://Data/function.json")
	# functions = LoadFileData("functions.json")

func LoadFileData(FilePath):
	var DataFile = File.new()
	var DataJSon
	DataFile.open(FilePath, File.READ)
	DataJSon = JSON.parse(DataFile.get_as_text())
	DataFile.close()
	return DataJSon.result

func getFunctions():
	print(LoadFileData("res://Data/function.json"))
	return LoadFileData("res://Data/function.json")