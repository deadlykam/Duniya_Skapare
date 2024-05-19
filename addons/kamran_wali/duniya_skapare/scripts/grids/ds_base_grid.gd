@tool
class_name DS_BaseGrid
extends Node

@export_category("Grid")
@export var _grid_x:= 3
@export var _grid_y:= 3
@export var _grid_z:= 0

var _tiles: Array[DS_Tile]

func _ready() -> void:
	setup()

## This method gets the x-axis size of the grid.
func get_grid_size_x() -> int:
	return _grid_x

## This method gets the y-axis size of the grid.
func get_grid_size_y() -> int:
	return _grid_y

## This method gets the z-axis size of the grid which is the height.
func get_grid_size_z() -> int:
	return _grid_z

## This method gets the total size of the grid.
func get_size() -> int:
	return _grid_x * _grid_y + ((_grid_x * _grid_y) * _grid_z)

## This method gets the indexth tile.
func get_tile(index:int) -> DS_Tile:
	return _tiles[index]

## This method adds a tile to the tile array.
func add_tile(tile:DS_Tile) -> void:
	_tiles.append(tile)

## This method sets up the grid.
func setup() -> void:
	pass

## This method resets the grid.
func reset() -> void:
	pass

## This method returns the grid in string format.
## The tile information are shown in the grid.
## Use this for debugging.
func show_grid_tile() -> String:
	return "Not implemented!"

## This method returns the grid in string format.
## The tile information are shown in the grid.
## It also highlights the indexth tile.
## Use this for debugging.
func show_grid_tile_index(index:int) -> String:
	return "Not implemented!"

## This method returns the grid in string format.
## The tile rotation information are shown in the grid.
## Use this for debugging.
func show_grid_tile_rot() -> String:
	return "Not implemented!"

# TODO: Rot array

## This method returns the grid in string format.
## The tile rotation information are shown in the grid.
## It also highlights the indexth tile.
## Use this for debugging.
func show_grid_tile_rot_index(index:int) -> String:
	return "Not implemented!"

## This method returns the grid in string format.
## The index of the tile are shown in the grid.
## Use this for debugging.
func show_grid_index() -> String:
	return "Not implemented!"

## This method returns the grid in string format.
## The index of the tile are shown in the grid.
## It also highlights the indexth tile.
## Use this for debugging.
func show_grid_index_index(index: int) -> String:
	return "Not implemented!"

# TODO: Index array

## This method always sends true as the script is 
## grid. This method is needed for duck
## typing check and SHOULD NOT be OVERRIDDEN!
func _is_grid() -> bool:
	return true
