@tool
extends Node

@export_category("Set Tile Type")
var _tile_type: int
@export var _grid_index: Array[int]

# Data Properties
var _data_names: DS_FixedStringArray = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse_settings/data_names.tres")

var _generator: DS_BaseGen
var _type_names: String
var _counter:= -1

func _get_property_list():
	var properties = []

	_type_names = ""
	_counter = 0
	# Loop for loading up all the type names
	while _counter < _data_names.get_size():
		_type_names += (_data_names.get_element(_counter) + 
			("," if _counter < _data_names.get_size() - 1 else ""))
		_counter += 1

	# Showing the names as enums
	properties.append({
		"name" : "_tile_type",
		"type" : TYPE_INT,
		"hint" : PROPERTY_HINT_ENUM,
		"hint_string" : _type_names
	})

	return properties

# TODO: Give warning for parent NOT found
# TODO: Send the tile info in _ready and make sure that code is in play mode