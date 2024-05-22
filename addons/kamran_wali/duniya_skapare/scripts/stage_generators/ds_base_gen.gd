@tool
class_name DS_BaseGen
extends Node

var _grid: DS_BaseGrid
var _start_tiles: Array[DS_TileInfo]
var _counter_warning:= -1 # This counter is for warnings ONLY
var _counter:= -1

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	
	if get_child_count() == 0:
		warnings.append("Gen: Please give a child containing the grid.")
	else:
		set_grid()
		if _grid == null:
			warnings.append("Gen: No Grid found in children. Please give a child containing the grid.")
	
	return warnings

func _ready() -> void:
	if !Engine.is_editor_hint():
		set_grid()
		setup() # Setting up the grid

## This method gets the grid.
func get_grid() -> DS_BaseGrid:
	return _grid

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
	while _counter < _grid.get_tile_size(): # Loop for finding the index of the tile
		if tile == _grid.get_tile(_counter): # Index found for the tile
			break
		_counter += 1
	
	return _counter if _counter < _grid.get_grid_size() else -1

## This method gets the start tile array.
func get_start_tiles() -> Array[DS_TileInfo]:
	return _start_tiles

## This method adds a tile to be processed first when the 
## setup starts.
func add_start_tile(tile:DS_TileInfo) -> void:
	_start_tiles.append(tile)

## This method gets the starting tile index or the first
## indexth tile to be processed.
func get_start_index() -> int:
	return -1

## This method gets all the free edges of the given tile.
func tile_free_edges(tile:int) -> Array[int]:
	return []

## This method adds new tile/s to the indexth tile. The indexth
## tile MUST have a free spot to add the tiles otherwise it will
## NOT.
func add_tile(tile:int, free_edges:Array[int]) -> void:
	pass

## This method checks if the generator for successful or NOT.
func is_gen_success() -> bool:
	return false

## This method gets the number of process loop value.
func get_process_loop() -> int:
	return -1

## This method sets up the generator and MUST be overridden.
func setup() -> void:
	pass

## This method resets the generator.
func reset() -> void:
	pass

## This method gets the complete process time from start to finish
## of the generator.
func get_run_time() -> float:
	return -1

## This method checks if the generator is processing or NOT.
func is_gen_process() -> bool: return false

## This method gets the data.
func get_data(): # NOTE: The type must be none-type because other gens may NOT have the same data.
	return null

## This method gets the name of the tiles.
func get_tile_names():
	return null

## This method prints the debug.
func print_debug_info() -> void:
	pass

func _to_string() -> String:
	return _grid.show_grid()

## This method always sends true as the script is generator.
## This method is needed for duck typing check and SHOULD
## NOT be OVERRIDDEN!
func _is_gen() -> bool:
	return true