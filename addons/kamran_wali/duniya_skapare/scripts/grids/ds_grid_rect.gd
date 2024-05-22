@tool
extends DS_BaseGrid

var _index:= -1
var _counter_x:= -1
var _counter_y:= -1
var _counter_z:= -1
var _c_search:= -1
var _debug_print: String
var _is_first_element: bool
var _has_element: bool

func show_grid_tile_array(tiles: Array[int]) -> String:
	_index = 0
	_counter_z = 0
	_is_first_element = true
	print("Showing Grid with tile information:")
	_debug_print = ""

	while _counter_z <= get_grid_size_z(): # Loop for going through grid z-axis, which is height
		_debug_print += "At height " + str(_counter_z) +": \n"
		_counter_y = 0

		while _counter_y < get_grid_size_y(): # Loop for going through y-axis
			_counter_x = 0

			while _counter_x < get_grid_size_x(): # Loop for going through x-axis
				_has_element = tiles.has(_index) # Checking and storing if tiles has the indexth element

				if _has_element: # Condition for showing correct colour
					_debug_print += ("[color=green]" if _is_first_element else 
						"[color=#00d5ff]" if _tiles[_index].is_fixed() else "[color=orange]")
				
				_debug_print += (
					(str(_tiles[_index].get_tile_type()) if _tiles[_index].get_tile_type() != -1 else "[color=red]X[/color]") 
					+ 
					(
						"   " if _tiles[_index].get_tile_type() < 10 else 
						"  " if _tiles[_index].get_tile_type() < 100 else
						" "
					)
				)

				if _has_element: # Condition for closing the colour
					_debug_print += ("[/color]")
					if _is_first_element: _is_first_element = false # First element has been set
				
				_index += 1
				_counter_x += 1
			
			_debug_print += "\n"
			_counter_y += 1
		
		_counter_z += 1
	
	_debug_print += "===xxx==="
	return _debug_print

func show_grid_tile_index(index:int) -> String:
	return show_grid_tile_array([index])

func show_grid_tile() -> String:
	return show_grid_tile_index(-1)

func show_grid_tile_rot_array(tiles: Array[int]) -> String:
	_index = 0
	_counter_z = 0
	_is_first_element = true
	print("Showing Grid with tile rotation information:")
	_debug_print = ""

	while _counter_z <= get_grid_size_z(): # Loop for going through grid z-axis, which is height
		_debug_print += "At height " + str(_counter_z) +": \n"
		_counter_y = 0

		while _counter_y < get_grid_size_y(): # Loop for going through y-axis
			_counter_x = 0

			while _counter_x < get_grid_size_x(): # Loop for going through x-axis
				_has_element = tiles.has(_index) # Checking and storing if tiles has the indexth element

				if _has_element: # Condition for showing correct colour
					_debug_print += ("[color=green]" if _is_first_element else 
						"[color=#00d5ff]" if _tiles[_index].is_fixed() else "[color=orange]")

				_debug_print += (
					("[color=red]" if _tiles[_index].get_tile_type() == -1 else "") +
					str(_tiles[_index].get_tile_rotation()) + 
					("[/color]" if _tiles[_index].get_tile_type() == -1 else "") +
					(
						"   " if _tiles[_index].get_tile_rotation() < 10 else 
						"  " if _tiles[_index].get_tile_rotation() < 100 else " "
					)
				)
				if _has_element: # Condition for closing the colour
					_debug_print += ("[/color]")
					if _is_first_element: _is_first_element = false # First element has been set
				
				_index += 1
				_counter_x += 1
			
			_debug_print += "\n"
			_counter_y += 1
		
		_counter_z += 1
	
	_debug_print += "===xxx==="
	return _debug_print

func show_grid_tile_rot_index(index:int) -> String:
	return show_grid_tile_rot_array([index])

## This method returns the grid in string format.
## The tile rotation information are shown in the grid.
## Use this for debugging.
func show_grid_tile_rot() -> String:
	return show_grid_tile_rot_index(-1)

func show_grid_index_array(tiles: Array[int]) -> String:
	_index = 0
	_counter_z = 0
	_is_first_element = true
	print("Showing Grid with index:")
	_debug_print = ""

	while _counter_z <= get_grid_size_z(): # Loop for going through grid z-axis, which is height
		_debug_print += "At height " + str(_counter_z) +": \n"
		_counter_y = 0

		while _counter_y < get_grid_size_y(): # Loop for going through y-axis
			_counter_x = 0

			while _counter_x < get_grid_size_x(): # Loop for going through x-axis
				_has_element = tiles.has(_index) # Checking and storing if tiles has the indexth element
				
				if _has_element: # Condition for showing correct colour
					_debug_print += ("[color=green]" if _is_first_element else 
						"[color=#00d5ff]" if _tiles[_index].is_fixed() else "[color=orange]") 
				
				_debug_print += (
					("[color=red]" if _tiles[_index].get_tile_type() == -1 else "") +
					str(_index) + 
					("[/color]" if _tiles[_index].get_tile_type() == -1 else "") +
					("   " if _index < 10 else "  " if _index < 100 else " ")
				)

				if _has_element: # Condition for closing the colour
					_debug_print += ("[/color]")
					if _is_first_element: _is_first_element = false # First element has been set
				
				_index += 1
				_counter_x += 1
			
			_debug_print += "\n"
			_counter_y += 1
		
		_counter_z += 1
	
	_debug_print += "===xxx==="
	return _debug_print

func show_grid_index_index(index: int) -> String:
	return show_grid_index_array([index])

func show_grid_index() -> String:
	return show_grid_index_index(-1)

func show_grid_coord_array(tiles: Array[int]) -> String:
	_index = 0
	_counter_z = 0
	_is_first_element = true
	print("Showing Grid with tile information:")
	_debug_print = ""

	while _counter_z <= get_grid_size_z(): # Loop for going through grid z-axis, which is height
		_debug_print += "At height " + str(_counter_z) +": \n"
		_counter_y = 0

		while _counter_y < get_grid_size_y(): # Loop for going through y-axis
			_counter_x = 0

			while _counter_x < get_grid_size_x(): # Loop for going through x-axis
				_has_element = tiles.has(_index) # Checking and storing if tiles has the indexth element

				if _has_element: # Condition for showing correct colour
					_debug_print += ("[color=green]" if _is_first_element else 
						"[color=#00d5ff]" if _tiles[_index].is_fixed() else "[color=orange]")
				
				_debug_print += (
					"(" + str(_tiles[_index].get_x()) + ", " + str(_tiles[_index].get_y()) + ", " + str(_tiles[_index].get_z()) + ") "
				)

				if _has_element: # Condition for closing the colour
					_debug_print += ("[/color]")
					if _is_first_element: _is_first_element = false # First element has been set
				
				_index += 1
				_counter_x += 1
			
			_debug_print += "\n"
			_counter_y += 1
		
		_counter_z += 1
	
	_debug_print += "===xxx==="
	return _debug_print

func setup() -> void:
	_counter_x = 0 # Array setup counter

	while _counter_x < get_grid_size(): # Loop to create tile array
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
					_tiles[_index - get_grid_size_x()] if
					_counter_y > 0
					else null
				)
				
				# Adding sourth tile refs
				_tiles[_index].set_south(
					_tiles[_index + get_grid_size_x()] if
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
				
				get_tile(_index).set_coord(_counter_x, _counter_y, _counter_z) # Setting the coordinate of the tile
				
				_index += 1
				_counter_x += 1
			
			_counter_y += 1
		
		_counter_z += 1

func reset() -> void:
	_counter_z = 0 # Acts as index for all the tiles in grid
	while _counter_z < get_grid_size(): # Loop for resetting all the tiles
		get_tile(_counter_z).reset_hard() # Hard resetting tile
		_counter_z += 1

func get_tile_coord_x_y_z(x:int, y:int, z:int) -> DS_Tile:
	# NOTE: The counter _c_search is being used in has_tile_coord_x_y_z.
	#		So if a match is found then the counter will point to that tile.
	#		Thus no extra logic writing is needed or copying pasting the code.
	#		Make sure _c_search does NOT change between these two methods.
	return _tiles[_c_search] if has_tile_coord_x_y_z(x, y, z) else null

func has_tile_coord(tile:DS_Tile) -> bool:
	_c_search = 0
	while _c_search < _tiles.size(): # Loop for searching through all the tiles
		if _tiles[_c_search].is_coord_match(tile): return true # Match found
		_c_search += 1
	return false # Match NOT found

func has_tile_coord_x_y_z(x:int, y:int, z:int) -> bool:
	_c_search = 0
	while _c_search < _tiles.size(): # Loop for searching through all the tiles
		if _tiles[_c_search].is_coord_match_x_y_z(x, y, z): return true # Match found
		_c_search += 1
	
	return false

func _to_string() -> String:
	print_rich(show_grid_index())
	return ""
