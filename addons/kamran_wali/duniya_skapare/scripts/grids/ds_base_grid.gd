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
var _debug_print: String

func _ready() -> void:
    _setup()

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

## This method returns the grid in string format.
## Use this for debugging.
func show_grid() -> String:
    return "Not implemented!"

## This method returns the grid in string format.
## It also highlights the indexth tile.
## Use this for debugging.
func show_grid_index(index:int) -> String:
    return "Not implemented!"

## This method sets up the grid.
func _setup() -> void:
    pass

## This method always sends true as the script is 
## grid. This method is needed for duck
## typing check and SHOULD NOT be OVERRIDDEN!
func _is_grid() -> bool:
    return true