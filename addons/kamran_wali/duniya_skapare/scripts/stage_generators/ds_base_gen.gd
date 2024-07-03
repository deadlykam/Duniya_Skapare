@tool
class_name DS_BaseGen
extends Node

@export_category("DS_BaseGen")
@export var _is_start_setup:= true

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
		set_grid() # Searching for grid child
		if _is_start_setup: setup() # Condition for setting up the grid

## This method gets the grid.
func get_grid() -> DS_BaseGrid: return _grid

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
	while _counter < _grid.get_tiles_size(): # Loop for finding the index of the tile
		if tile == _grid.get_tile(_counter): # Index found for the tile
			break
		_counter += 1
	
	return _counter if _counter < _grid.get_tiles_size() else -1

## This method gets the start tile array.
func get_start_tiles() -> Array[DS_TileInfo]: return _start_tiles

## This method adds a tile to be processed first when the setup starts.
func add_start_tile(tile:DS_TileInfo) -> void: _start_tiles.append(tile)

## This method checks if the given height value is within the range or NOT.
func is_tile_height_z(height:int) -> bool: return height >= 0 and height <= get_grid().get_grid_size_z()

## This method checks if the tile height is within the range or NOT.
func is_tile_height(tile:DS_Tile) -> bool: return is_tile_height_z(tile.get_z())

## This method gets the starting tile index or the first
## indexth tile to be processed.
func get_start_index() -> int:
	print_rich("[color=orange]WARNING: [i]int get_start_index()[/i] has NOT been implemented![/color]")
	return -1

## This method gets all the free edges of the given tile.
func get_tile_free_edges(tile:DS_Tile) -> Array[int]:
	print_rich("[color=orange]WARNING: [i]Array[int] get_tile_free_edges(DS_Tile)[/i] has NOT been implemented![/color]")
	return []

## This method expands the grid in the given direction.
## UP = 0
## North = 1
## East = 2
## Bottom = 3
## South = 4
## West = 5
func expand_grid(dir:int) -> void:
	print_rich("[color=orange]WARNING: [i]void expand_grid(int)[/i] has NOT been implemented![/color]")

## This method adds new tile/s to the given tile edges'. The given tile MUST have
## at least one free spot to add the new tile otherwise it will NOT.
func add_tile(tile:DS_Tile) -> void:
	print_rich("[color=orange]WARNING: [i]void add_tile(DS_Tile)[/i] has NOT been implemented![/color]")

## This method adds new tile/s to the given indexth tile edges'. The given 
## tile MUST have at least one free spot to add the new tile otherwise it will NOT.
func add_tile_index(tile:int) -> void: add_tile(_grid.get_tile(tile))

## This method checks if the start setup has been enabled or disabled.
func is_start_setup() -> bool: return _is_start_setup

## This method checks if the generator for successful or NOT.
func is_gen_success() -> bool: return false

## This method gets the number of process loop value.
func get_process_loop() -> int:
	print_rich("[color=orange]WARNING: [i]int get_process_loop()[/i] has NOT been implemented![/color]")
	return -1

## This method sets up the generator and MUST be overridden.
func setup() -> void:
	print_rich("[color=orange]WARNING: [i]void setup()[/i] has NOT been implemented![/color]")

## This method resets the generator.
func reset() -> void:
	print_rich("[color=orange]WARNING: [i]void reset()[/i] has NOT been implemented![/color]")

## This method gets the complete process time from start to finish
## of the generator.
func get_run_time() -> float:
	print_rich("[color=orange]WARNING: [i]float get_run_time()[/i] has NOT been implemented![/color]")
	return -1

## This method checks if the generator is processing or NOT.
func is_gen_process() -> bool: return false

## This method gets the data.
func get_data(): # NOTE: The type must be none-type because other gens may NOT have the same data.
	print_rich("[color=orange]WARNING: [i]void get_data()[/i] has NOT been implemented![/color]")
	return null

## This method gets the name of the tiles.
func get_tile_names():
	print_rich("[color=orange]WARNING: get_tile_names() has NOT been implemented![/color]")
	return null

## This method gets the stage loaded normal value which is the percentage loaded value.
## Range is from 0.0 to 1.0.
func get_percentage_loaded_normal() -> float:
	print_rich("[color=orange]WARNING: get_percentage_loaded_normal() has NOT been implemented![/color]")
	return -1.0

## This method prints the debug.
func print_debug_info() -> void:
	print_rich("[color=orange]WARNING: [i]void print_debug_info()[/i] has NOT been implemented![/color]")

func _to_string() -> String: return _grid.show_grid()

## This method always sends true as the script is generator.
## This method is needed for duck typing check and SHOULD
## NOT be OVERRIDDEN!
func _is_gen() -> bool: return true
