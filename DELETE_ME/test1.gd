extends Node

@export var _generator: DS_BaseGen

var _tile: DS_Tile
var _x:= 0
var _y:= 0
var _z:= 0

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		if _generator.get_grid().has_tile_coord_x_y_z(_x, _y - 1, _z): _y -= 1
		print("Position: (", _x, ", ", _y, ", ", _z, ")")
	elif Input.is_action_just_pressed("ui_down"):
		if _generator.get_grid().has_tile_coord_x_y_z(_x, _y + 1, _z): _y += 1
		print("Position: (", _x, ", ", _y, ", ", _z, ")")
	elif Input.is_action_just_pressed("ui_left"):
		if _generator.get_grid().has_tile_coord_x_y_z(_x - 1, _y, _z): _x -= 1
		print("Position: (", _x, ", ", _y, ", ", _z, ")")
	elif Input.is_action_just_pressed("ui_right"):
		if _generator.get_grid().has_tile_coord_x_y_z(_x + 1, _y, _z): _x += 1
		print("Position: (", _x, ", ", _y, ", ", _z, ")")
	elif Input.is_action_just_pressed("ui_end"):
		_tile = _generator.get_grid().get_tile_coord_x_y_z(_x, _y, _z)
		print("Tile Coord: (", _tile.get_x(), ", ", _tile.get_y(), ", ", _tile.get_z(), ")")
		print("Tile Index: ", _generator.get_tile_index(_tile))
		_generator.add_tile_index(_generator.get_tile_index(_tile))
		# _generator.add_tile(0)
			
