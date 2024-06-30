@tool
class_name DS_BaseGrid
extends Node

@export_category("Grid")
@export var _grid_x:= 3:
	set(grid_x):
		if _grid_x != grid_x:
			_grid_x = grid_x if grid_x >= 1 else 1

@export var _grid_y:= 3:
	set(grid_y):
		if _grid_y != grid_y:
			_grid_y = grid_y if grid_y >= 1 else 1

# region Grid_Z
# NOTE: For now the input for grid z is disabled as height requires
#		further testing and atm it seems like height isn't working.
#		Keeping the zombie code for taking the grid z input. Making
#		_grid_z value to zero as default for now. Below is the
#		the zombie code for taking _grid_z input value and below
#		that is the current default value for _grid_z.

# @export var _grid_z:= 0:
# 	set(grid_z):
# 		if _grid_z != grid_z:
# 			_grid_z = grid_z if grid_z >= 0 else 0
var _grid_z = 0
#endregion

var _tiles: Array[DS_Tile]

func _ready() -> void: setup()

## This method gets the x-axis size of the grid.
func get_grid_size_x() -> int: return _grid_x

## This method gets the y-axis size of the grid.
func get_grid_size_y() -> int: return _grid_y

## This method gets the z-axis size of the grid which is the height.
func get_grid_size_z() -> int: return _grid_z

## This method gets the total size of the grid.
func get_grid_size() -> int: return _grid_x * _grid_y + ((_grid_x * _grid_y) * _grid_z)

## This method gets the tile array size.
func get_tiles_size() -> int: return _tiles.size()

## This method gets the indexth tile.
func get_tile(index:int) -> DS_Tile: return _tiles[index] if index < _tiles.size() else null

## This method adds a tile to the tile array.
func add_tile(tile:DS_Tile) -> void: _tiles.append(tile)

## This method checks if the given tile exists in the given grid and if it does
## exists then it will return the tile otherwise will return null.
func get_tile_coord_grid(tile:DS_Tile, grid:Array[DS_Tile]) -> DS_Tile: return null

## This method checks if the given tile exists and if it does exists then it will return
## the tile otherwise will return null.
func get_tile_coord(tile:DS_Tile) -> DS_Tile: return get_tile_coord_grid(tile, _tiles)

## This method searches for the coordinated tile in the given grid and returns it.
func get_tile_coord_x_y_z_grid(x:int, y:int, z:int, grid:Array[DS_Tile]) -> DS_Tile: return null

## This method searches for the coordinated tile and returns it.
func get_tile_coord_x_y_z(x:int, y:int, z:int) -> DS_Tile: return get_tile_coord_x_y_z_grid(x, y, z, _tiles)

## This method checks if the give tile exists using its coordinates in the given grid.
func has_tile_coord_grid(tile:DS_Tile, grid:Array[DS_Tile]) -> bool: return false

## This method checks if the given tile exists using its coordinates.
func has_tile_coord(tile:DS_Tile) -> bool: return has_tile_coord_grid(tile, _tiles)

## This method checks if the given coordinate exists in the given tile.
func has_tile_coord_x_y_z_grid(x:int, y:int, z:int, grid:Array[DS_Tile]) -> bool: return false

## This method checks if the given coordinate exists.
func has_tile_coord_x_y_z(x:int, y:int, z:int) -> bool: return has_tile_coord_x_y_z_grid(x, y, z, _tiles)

## This method sets up the grid.
func setup() -> void: pass

## This method resets the grid.
func reset() -> void: pass

## This method returns the grid in string format.
## The tile information are shown in the grid.
## Use this for debugging.
func show_grid_tile() -> String: return "Not implemented!"

## This method returns the grid in string format.
## The tile information are shown in the grid.
## It also highlights the indexth tile.
## Use this for debugging.
func show_grid_tile_index(index:int) -> String: return "Not implemented!"

## This method returns the grid in string format.
## The tile information are shown in the grid.
## It also highlights an array of index tiles.
## The first index is highlighted green and the
## rest are blue. Use this for debuggin.
func show_grid_tile_array(tiles: Array[int]) -> String: return "Not implemented!"

## This method returns the grid in string format.
## The tile rotation information are shown in the grid.
## Use this for debugging.
func show_grid_tile_rot() -> String: return "Not implemented!"

## This method returns the grid in string format.
## The tile rotation information are shown in the grid.
## It also highlights the indexth tile.
## Use this for debugging.
func show_grid_tile_rot_index(index:int) -> String: return "Not implemented!"

## This method returns the grid in string format.
## The tile rotation information are shown in the grid.
## It also highlights an array of index tiles.
## The first index is highlighted green and the rest
## are blue. Use this for debuggin.
func show_grid_tile_rot_array(tiles: Array[int]) -> String: return "Not implemented!"

## This method returns the grid in string format.
## The index of the tile are shown in the grid.
## Use this for debugging.
func show_grid_index() -> String: return "Not implemented!"

## This method returns the grid in string format.
## The index of the tile are shown in the grid.
## It also highlights the indexth tile.
## Use this for debugging.
func show_grid_index_index(index: int) -> String: return "Not implemented!"

## This method returns the grid in string format.
## The index of the tile are shown in the grid.
## It also highlights an array of index tiles.
## The first index is highlighted green and the rest
## are blue. Use this for debuggin.
func show_grid_index_array(tiles: Array[int]) -> String: return "Not implemented!"

## This method returns the grid in string format.
## The coordinate of the tiles are shown in the grid.
## Use this for debugging.
func show_grid_coord() -> String: return "Not implemented!"

## This method returns the grid in string format.
## The coordinates of the tiles are shown in the grid.
## It also highlights the indexth tile.
## Use this for debugging.
func show_grid_coord_index(index: int) -> String: return "Not implemented!"

## This method returns the grid in string format.
## The coordinates of the tiles are shown in the grid.
## It also highlights an array of coordinate tiles.
## The first index is highlighted green. The fixed
## tiles are highlighted blue and the none fixed tiles
## are highlighted orange.
func show_grid_coord_array(tiles: Array[int]) -> String: return "Not implemented!"

## This method always sends true as the script is 
## grid. This method is needed for duck
## typing check and SHOULD NOT be OVERRIDDEN!
func _is_grid() -> bool: return true
