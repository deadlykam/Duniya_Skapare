@tool
class_name DS_Tile

var _tile_type:= -1
var _data_edges: Array[DS_Tile] # Edges
var _rot_value:= 0

func _init() -> void:
	_data_edges.resize(6)

## This method resets the tile.
func reset_tile() -> void:
	_tile_type = -1
	_rot_value = 0

## This method sets the type of the tile.
func set_tile_type(tile_type:int) -> void:
	_tile_type = tile_type

## This method gets the type of the tile.
func get_tile_type() -> int:
	return _tile_type

## This method sets the type of tile for the linked tiles.
## UP = 0
## North = 1
## East = 2
## Bottom = 3
## South = 4
## West = 5
func set_edge(cd: DS_Tile, index:int) -> void:
	_data_edges[index] = cd

## This method gets the linked tile.
## UP = 0
## North = 1
## East = 2
## Bottom = 3
## South = 4
## West = 5
func get_edge(index:int) -> DS_Tile:
	return _data_edges[index]

## This method gets the linked tile after rotating the tile. So 
## depending on the rotation of the tile the edges can be anywhere.
## 1 rotation will rotate the tile by (360/number of edges) degrees.
func get_rotational_edge(index:int) -> DS_Tile:
	return _data_edges[get_rotational_edge_index(index)]

## This method gets the size of the edge array 
## which MUST always be 4.
func get_edge_size() -> int:
	return _data_edges.size()

## This method sets the north tile.
func set_up(up: DS_Tile) -> void:
	set_edge(up, 0)

## This method gets the north tile.
func get_up() -> DS_Tile:
	return get_edge(0)

## This method sets the north tile.
func set_north(north: DS_Tile) -> void:
	set_edge(north, 1)

## This method gets the north tile.
func get_north() -> DS_Tile:
	return get_edge(1)

## This method sets the east tile.
func set_east(east: DS_Tile) -> void:
	set_edge(east, 2)

## This method gets the east tile.
func get_east() -> DS_Tile:
	return get_edge(2)

## This method sets the bottom tile.
func set_bottom(bottom: DS_Tile) -> void:
	set_edge(bottom, 3)

## This method gets the bottom tile.
func get_bottom() -> DS_Tile:
	return get_edge(3)

## This method sets the south tile.
func set_south(south: DS_Tile) -> void:
	set_edge(south, 4)

## This method gets the south tile.
func get_south() -> DS_Tile:
	return get_edge(4)

## This method sets the west tile.
func set_west(west: DS_Tile) -> void:
	set_edge(west, 5)

## This method gets the north tile.
func get_west() -> DS_Tile:
	return get_edge(5)

## This method gets the rotation of the tile.
func get_tile_rotation() -> float:
	return (360 / _data_edges.size()) * _rot_value

## This sets the rotation value of the tile. 1 rot_value 
## is equivalent to (360/number of cardinals) degrees.
func set_tile_rotation_value(rot_value:int) -> void:
	_rot_value = (0 if rot_value < 0 
		else _data_edges.size() - 1 if rot_value >= _data_edges.size() 
		else rot_value)

## This method gets the rotation value of the tile.
func get_tile_rotation_value() -> int:
	return _rot_value

## This method gets the edge index after the tile 
## has been rotated
func get_rotational_edge_index(index:int) -> int:
	return (index - _rot_value if (index - _rot_value) >= 0 
		else _data_edges.size() + (index - _rot_value))