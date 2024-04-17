@tool
class_name DS_Grid
extends Node

@export_category("Grid")
@export var _grid_x:= 3
@export var _grid_y:= 3

var _tiles: Array[DS_Tile]
var _index:= -1
var _counter1:= -1
var _counter2:= -1

func _ready() -> void:
    _counter1 = 0

    # Loop for initiating tiles
    while _counter1 < (_grid_x * _grid_y):
        _tiles.append(DS_Tile.new()) # Adding initiated tiles
        _counter1 += 1
    
    _index = 0
    _counter1 = 0 # Y-axis counter

    while _counter1 < _grid_y: # Loop for going through y-axis tiles
        _counter2 = 0 # X-axis counter

        while _counter2 < _grid_x: # Loop for going through x-axis tiles

            # Adding north tile refs
            _tiles[_index].set_north(
                _tiles[_index - _grid_y] if
                _counter1 > 0 #&& (_counter1 <= _grid_y - 1)
                else null
            )
            
            # Adding sourth tile refs
            _tiles[_index].set_south(
                _tiles[_index + _grid_y] if
                _counter1 < _grid_y - 1
                else null
            )
            
            # Adding west tile refs
            _tiles[_index].set_west(
                _tiles[_index - 1] if
                _counter2 > 0 #&& (_counter2 <= _grid_x - 1)
                else null
            )
            
            # Adding east tile refs
            _tiles[_index].set_east(
                _tiles[_index + 1] if 
                _counter2 < _grid_x - 1
                else null
            )
            
            _index += 1
            _counter2 += 1
        _counter1 += 1

## This method gets the x-axis size of the grid.
func get_grid_size_x() -> int:
    return _grid_x

## This method gets the y-axis size of the grid.
func get_grid_size_y() -> int:
    return _grid_y

## This method gets the total size of the grid.
func get_size() -> int:
    return _grid_x * _grid_y

## This method gets the indexth tile.
func get_tile(index:int) -> DS_Tile:
    return _tiles[index]