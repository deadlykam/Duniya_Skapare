@tool
class_name DS_GridRect
extends DS_Grid

func show_grid() -> String:
	return show_grid_index(-1)

func show_grid_index(index:int) -> String:
	_index = 0
	_counter1 = 0
	_debug_print = ""

	# Loop for printing the grid
	while _counter1 < _grid_y:
		_counter2 = 0

		# Loop for storing all the x-axis values for printing
		while _counter2 < _grid_x:
			_debug_print += (("[color=green]" if _index == index else "") + 
								str(_tiles[_index].get_tile_type()) +
								("[/color]" if _index == index else "") 
								+ " ")
			_index += 1
			_counter2 += 1
		
		_debug_print += "\n"
		_counter1 += 1
	
	return _debug_print

## This method sets up the grid.
func _setup() -> void:
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

func _to_string() -> String:
	print_rich(show_grid())
	return ""