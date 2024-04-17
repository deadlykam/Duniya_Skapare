extends Node

@export var _grid: DS_Grid
@export var _wfc: DS_WFCGen

var _counter
var _counter2
var _tile: DS_Tile
var _tiles_open: Array[DS_Tile]
var _tiles_closed: Array[DS_Tile]
var _tile_types: String

func _ready():
	_grid.print_grid()
