@tool
class_name DS_Tile

var _tile_type:= -1
var _data_cd: Array[DS_Tile] # Cardinal Directions
var _rot_value:= 0

func _init() -> void:
    _data_cd.resize(4)

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
## 0 = North
## 1 = East
## 2 = South
## 3 = West
func set_cardinal_direction(cd: DS_Tile, index:int) -> void:
    _data_cd[index] = cd

## This method gets the linked tile.
## 0 = North
## 1 = East
## 2 = South
## 3 = West
func get_cardinal_direction(index:int) -> DS_Tile:
    return _data_cd[index]

## This method gets the linked tile after rotating the tile. So 
## depending on the rotation of the tile the cardinals can be anywhere.
## 1 rotation will rotate the tile by (360/number of cardinals) degrees.
func get_rotational_cardinal_direction(index:int) -> DS_Tile:
    return _data_cd[get_rotational_cardinal_index(index)]

## This method gets the size of the cardinal direction array 
## which MUST always be 4.
func get_cardinal_direction_size() -> int:
    return _data_cd.size()

## This method sets the north tile.
func set_north(north: DS_Tile) -> void:
    set_cardinal_direction(north, 0)

## This method gets the north tile.
func get_north() -> DS_Tile:
    return get_cardinal_direction(0)

## This method sets the east tile.
func set_east(east: DS_Tile) -> void:
    set_cardinal_direction(east, 1)

## This method gets the east tile.
func get_east() -> DS_Tile:
    return get_cardinal_direction(1)

## This method sets the south tile.
func set_south(south: DS_Tile) -> void:
    set_cardinal_direction(south, 2)

## This method gets the south tile.
func get_south() -> DS_Tile:
    return get_cardinal_direction(2)

## This method sets the west tile.
func set_west(west: DS_Tile) -> void:
    set_cardinal_direction(west, 3)

## This method gets the north tile.
func get_west() -> DS_Tile:
    return get_cardinal_direction(3)

## This method gets the rotation of the tile.
func get_tile_rotation() -> float:
    return (360 / _data_cd.size()) * _rot_value

## This sets the rotation value of the tile. 1 rot_value 
## is equivalent to (360/number of cardinals) degrees.
func set_tile_rotation_value(rot_value:int) -> void:
    _rot_value = (0 if rot_value < 0 
        else _data_cd.size() - 1 if rot_value >= _data_cd.size() 
        else rot_value)

## This method gets the rotation value of the tile.
func get_tile_rotation_value() -> int:
    return _rot_value

## This method gets the cardinal index after the tile 
## has been rotated
func get_rotational_cardinal_index(index:int) -> int:
    return (index - _rot_value if (index - _rot_value) >= 0 
        else _data_cd.size() + (index - _rot_value))