@tool
class_name DS_BaseGen
extends Node

# Constants
const TILE_INFO: GDScript = preload("res://addons/kamran_wali/duniya_skapare/scripts/grids/ds_tile_info.gd")

var _grid: DS_BaseGrid
var _counter_warning:= -1 # This counter is for warnings ONLY
var _update_tile_info: Array[TILE_INFO]
var _counter:= -1

func _get_configuration_warnings():
	var warnings: Array[String]
	
	if get_child_count() == 0:
		warnings.append("Gen: Please give a child containing the grid.")
	else:
		if _search_grid_child() == null:
			warnings.append("Gen: No Grid found in children. Please give a child containing the grid.")
	
	return warnings

func _ready() -> void:
	if !Engine.is_editor_hint():
		_grid = _search_grid_child()
		_counter = 0
		
		# Loop for updating tiles at start
		while _counter < _update_tile_info.size():
			_grid.get_tile(_update_tile_info[_counter].get_index()).set_tile_type(_update_tile_info[_counter].get_tile_type())
			_counter += 1
        
		_setup() # Setting up the grid

## This method adds a tile info for updating a tile.
func add_update_tile_info(tile: TILE_INFO) -> void:
	_update_tile_info.append(tile)

## This method gets a tile from the grid.
func get_grid_tile(index:int) -> DS_Tile:
	return _grid.get_tile(index)

## This method gets all the updated tile info
func get_update_tile_info() -> Array[TILE_INFO]:
	return _update_tile_info

## This method gets the DS_Data.
func get_data() -> DS_Data:
	return DS_Data.get_instance()

## This method sets up the grid and MUST be overridden.
func _setup() -> void:
	pass

## This method searches for the grid child.
func _search_grid_child() -> DS_BaseGrid:
	_counter_warning = 0
	while _counter_warning < get_child_count():
		if get_child(_counter_warning).has_method("_is_grid"):
				return get_child(_counter_warning)
		_counter_warning += 1
	return null

func _to_string() -> String:
	return _grid.show_grid()

## This method always sends true as the script is generator.
## This method is needed for duck typing check and SHOULD
## NOT be OVERRIDDEN!
func _is_gen() -> bool:
	return true