@tool
class_name DS_BaseGen
extends Node

var _grid: DS_BaseGrid
var _counter_warning:= -1 # This counter is for warnings ONLY
var _counter:= -1

func _get_configuration_warnings():
	var warnings: Array[String]
	
	if get_child_count() == 0:
		warnings.append("Gen: Please give a child containing the grid.")
	else:
		set_grid()
		if _grid == null:
			warnings.append("Gen: No Grid found in children. Please give a child containing the grid.")
		# if search_grid_child() == null:
		# 	warnings.append("Gen: No Grid found in children. Please give a child containing the grid.")

func _ready() -> void:
	if !Engine.is_editor_hint():
		set_grid()
		# _grid = search_grid_child()
		# _counter = 0
		
        # # Loop for updating tiles at start
		# while _counter < _update_tile_info.size():
		# 	_grid.get_tile(_update_tile_info[_counter].get_index()).set_tile_type(_update_tile_info[_counter].get_tile_type())
		# 	_counter += 1

		_setup() # Setting up the grid

## This method gets the grid.
func get_grid() -> DS_BaseGrid:
	return _grid

## This method gets the DS_Data.
func get_data() -> DS_Data:
	return DS_Data.get_instance()

## This method searches for the grid child.
func set_grid() -> void:
	_counter_warning = 0
	while _counter_warning < get_child_count(): # Loop for finding grid
		if get_child(_counter_warning).has_method("_is_grid"):
			_grid = get_child(_counter_warning)
			break
		_counter_warning += 1

## This method gets the index of the given tile.
func get_tile_index(tile:DS_Tile) -> int:
	_counter = 0
	while _counter < _grid.get_size(): # Loop for finding the index of the tile
		if tile == _grid.get_tile(_counter): # Index found for the tile
			break
		_counter += 1
	
	return _counter if _counter < _grid.get_size() else -1

## This method checks if the generator for successful or NOT.
func is_gen_success() -> bool:
	return false

## This method sets up the grid and MUST be overridden.
func _setup() -> void:
	pass

func _to_string() -> String:
	return _grid.show_grid()

## This method always sends true as the script is generator.
## This method is needed for duck typing check and SHOULD
## NOT be OVERRIDDEN!
func _is_gen() -> bool:
	return true