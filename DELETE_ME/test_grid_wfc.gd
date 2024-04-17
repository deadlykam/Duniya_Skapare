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
	
	var _index = 0
	_counter = 0

	while _counter < _grid.get_grid_size_y():
		_tile_types = ""
		_counter2 = 0
		while _counter2 < _grid.get_grid_size_x():
			_tile_types = _tile_types + str(_grid.get_tile(_index).get_tile_type()) + " "
			_index += 1
			_counter2 += 1
		print(_tile_types)
		_counter += 1

# func _ready():
# 	_counter = 0
# 	while _counter < _grid.get_size():
# 		_grid.get_tile(_counter).set_tile_type(_counter)
# 		_counter += 1
	
# 	_tiles_open.append(_grid.get_tile(0))

# 	while !_tiles_open.is_empty():
# 		_tile = _tiles_open.pop_front()
# 		print(_tile.get_tile_type())

# 		_counter = 0
# 		while _counter < _tile.get_cardinal_direction_size():
# 			if _tile.get_cardinal_direction(_counter) != null:
# 				if (!_tiles_closed.has(_tile.get_cardinal_direction(_counter)) && 
# 					!_tiles_open.has(_tile.get_cardinal_direction(_counter))):
# 						_tiles_open.append(_tile.get_cardinal_direction(_counter))
# 			_counter += 1
		
# 		_tiles_closed.append(_tile)
