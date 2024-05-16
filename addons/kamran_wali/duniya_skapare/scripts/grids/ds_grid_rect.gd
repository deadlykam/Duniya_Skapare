@tool
extends DS_BaseGrid

var _index:= -1
var _counter_x:= -1
var _counter_y:= -1
var _counter_z:= -1
var _debug_print: String

func show_grid_tile_index(index:int) -> String:
	_index = 0
	_counter_z = 0
	print("Showing Grid with tile information:")
	_debug_print = ""

	while _counter_z <= get_grid_size_z(): # Loop for going through grid z-axis, which is height
		_debug_print += "At height " + str(_counter_z) +": \n"
		_counter_y = 0

		while _counter_y < get_grid_size_y(): # Loop for going through y-axis
			_counter_x = 0

			while _counter_x < get_grid_size_x(): # Loop for going through x-axis
				_debug_print += (("[color=green]" if _index == index else "") + 
								str(_tiles[_index].get_tile_type()) +
								("[/color]" if _index == index else "") 
								+ "   ")
				
				_index += 1
				_counter_x += 1
			
			_debug_print += "\n"
			_counter_y += 1
		
		_counter_z += 1
	
	_debug_print += "===xxx==="
	return _debug_print

func show_grid_tile() -> String:
	return show_grid_tile_index(-1)

func show_grid_tile_rot_index(index:int) -> String:
	_index = 0
	_counter_z = 0
	print("Showing Grid with tile rotation information:")
	_debug_print = ""

	while _counter_z <= get_grid_size_z(): # Loop for going through grid z-axis, which is height
		_debug_print += "At height " + str(_counter_z) +": \n"
		_counter_y = 0

		while _counter_y < get_grid_size_y(): # Loop for going through y-axis
			_counter_x = 0

			while _counter_x < get_grid_size_x(): # Loop for going through x-axis
				_debug_print += (("[color=green]" if _index == index else "") + 
								str(_tiles[_index].get_tile_rotation()) +
								("[/color]" if _index == index else "") 
								+ "   ")
				
				_index += 1
				_counter_x += 1
			
			_debug_print += "\n"
			_counter_y += 1
		
		_counter_z += 1
	
	_debug_print += "===xxx==="
	return _debug_print

## This method returns the grid in string format.
## The tile rotation information are shown in the grid.
## Use this for debugging.
func show_grid_tile_rot() -> String:
	return show_grid_tile_rot_index(-1)

func show_grid_index_index(index: int) -> String:
	_index = 0
	_counter_z = 0
	print("Showing Grid with index:")
	_debug_print = ""

	while _counter_z <= get_grid_size_z(): # Loop for going through grid z-axis, which is height
		_debug_print += "At height " + str(_counter_z) +": \n"
		_counter_y = 0

		while _counter_y < get_grid_size_y(): # Loop for going through y-axis
			_counter_x = 0

			while _counter_x < get_grid_size_x(): # Loop for going through x-axis
				_debug_print += (("[color=green]" if _index == index else "") + 
								str(_index) +
								("[/color]" if _index == index else "") +
								("   " if _index < 10 else "  " if _index < 100 else " ") )
				
				_index += 1
				_counter_x += 1
			
			_debug_print += "\n"
			_counter_y += 1
		
		_counter_z += 1
	
	_debug_print += "===xxx==="
	return _debug_print

func show_grid_index() -> String:
	return show_grid_index_index(-1)

func setup() -> void:
	_counter_x = 0 # Array setup counter

	while _counter_x < get_size(): # Loop to create tile array
		add_tile(DS_Tile.new())
		_counter_x += 1
	
	_index = 0 # Tile index
	_counter_z = 0

	while _counter_z <= get_grid_size_z():
		_counter_y = 0 # Y-axis counter

		while _counter_y < get_grid_size_y():
			_counter_x = 0

			while _counter_x < get_grid_size_x():

				# Adding up tile refs
				get_tile(_index).set_up(
					get_tile(_index + (get_grid_size_x() * get_grid_size_y())) 
					if _counter_z < get_grid_size_z()
					else null
				)
				
				# Adding bottom tile refs
				get_tile(_index).set_bottom(
					get_tile(_index - (get_grid_size_x() * get_grid_size_y()))
					if _counter_z > 0
					else null
				)
				
				# Adding north tile refs
				_tiles[_index].set_north(
					_tiles[_index - get_grid_size_y()] if
					_counter_y > 0
					else null
				)
				
				# Adding sourth tile refs
				_tiles[_index].set_south(
					_tiles[_index + get_grid_size_y()] if
					_counter_y < get_grid_size_y() - 1
					else null
				)
				
				# Adding west tile refs
				_tiles[_index].set_west(
					_tiles[_index - 1] if
					_counter_x > 0
					else null
				)
				
				# Adding east tile refs
				_tiles[_index].set_east(
					_tiles[_index + 1] if 
					_counter_x < get_grid_size_x() - 1
					else null
				)
				
				_index += 1
				_counter_x += 1
			
			_counter_y += 1
		
		_counter_z += 1

func reset() -> void:
	_counter_z = 0 # Acts as index for all the tiles in grid
	while _counter_z < get_size(): # Loop for resetting all the tiles
		get_tile(_counter_z).reset_tile() # Resetting tile
		_counter_z += 1

func _to_string() -> String:
	print_rich(show_grid_index())
	return ""
