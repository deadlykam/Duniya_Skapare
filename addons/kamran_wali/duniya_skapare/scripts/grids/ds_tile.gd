@tool
class_name DS_Tile

var _tile_type:= -1
var _data_cd: Array[DS_Tile] # Cardinal Directions

func _init() -> void:
    _data_cd.resize(4)

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