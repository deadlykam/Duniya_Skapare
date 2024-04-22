@tool
extends Node

@export_category("Set Tile Type")
var _tile_type: int
@export var _grid_index: Array[int]

# Constants
const TILE_INFO: GDScript = preload("res://addons/kamran_wali/duniya_skapare/scripts/grids/ds_tile_info.gd")

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

func _get_configuration_warnings():
	var warnings: Array[String]

	if get_parent() == null:
		warnings.append("Set Tile Type: Please make sure object has a parent. Please give a parent containing the generator script")
	elif !get_parent().has_method("_is_gen"):
		warnings.append("Please give a parent containing the generator script.")
	
	return warnings

func _ready() -> void:
	if !Engine.is_editor_hint():
		_generator = get_parent()
		_counter = 0

		# Loop for sending all the tiles to be updated.
		while _counter < _grid_index.size():
			_generator.add_update_tile_info(TILE_INFO.new(_grid_index[_counter], _tile_type))
			_counter += 1