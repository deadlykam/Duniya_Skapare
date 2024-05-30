@tool
extends "res://addons/kamran_wali/duniya_skapare/scripts/stage_generators/wave_function_collapse/ds_wfc_base_continuous.gd"

# Properties for internal usage ONLY
var _tile_new: DS_Tile
var _x_min:= -1
var _x_max:= -1
var _y_min:= -1
var _y_max:= -1
var _z_min:= -1
var _c_x:= -1
var _c_y:= -1
var _c_z:= -1
var _is_add_first_tile = false

func setup() -> void:
	super()
	_x_min = 0
	_x_max = get_grid().get_grid_size_x()
	_y_min = 0
	_y_max = get_grid().get_grid_size_y()
	_z_min = get_grid().get_grid_size_z()

func expand_grid(dir:int) -> void:
	set_processing(true) # Starting processing
	start_debug_timer() # Starting the debug timer
	_is_add_first_tile = false # First tile has NOT been added for processing
	
	# Dynamic loop for expanding the grid
	_c_z = _z_min + 1 if dir == 0 else 0 # Up condition and correct starting z coordinate
	# Loop for creating the correct z coordinate tiles
	while _c_z <= _z_min + get_grid().get_grid_size_z() if dir == 0 else _c_z <= _z_min:
		# Getting the correct starting y coordinate
		_c_y = (_y_min - 1 if dir == 1 else # North Condition
				_y_max if dir == 4 else # South Condition
				_y_min) # Others
		# Loop for creating the correct y coordinate tiles
		while (_c_y > _y_min - get_grid().get_grid_size_y() - 1 if dir == 1 else # North Condition
				_c_y < _y_max + get_grid().get_grid_size_y() if dir == 4 else # South Condition
				_c_y < _y_max): # Others
			# Getting the correct starting x coordinate
			_c_x = (_x_min - 1 if dir == 5 else # West Condition
					_x_max if dir == 2 else # East Condition
					_x_min) # Others
			# Loop for creating the correct x coordinate tiles
			while (_c_x > _x_min - get_grid().get_grid_size_x() - 1 if dir == 5 else # West Condition
					_c_x < _x_max + get_grid().get_grid_size_x() if dir == 2 else # East Condition
					_c_x < _x_max): # Others
				_tile_new = DS_Tile.new() # Creating a new tile
				_tile_new.set_coord(_c_x, _c_y, _c_z) # Setting new tile's coordinates
				get_grid().add_tile(_tile_new) # Adding new tile to the main grid
				add_tile_to_connect(_tile_new) # Adding tile to connection processing

				if !_is_add_first_tile: # Condition for addinthe first tile to be processed
					add_tile_to_process(_tile_new) # Adding tile to main processing
					_is_add_first_tile = true # First tile added

				_c_x += -1 if dir == 5 else 1 # West will be the ONLY one incrementing in the -ve
			_c_y += -1 if dir == 1 else 1 # North will be the ONLY one incrementing in the -ve
		_c_z += 1

	if dir == 0: _z_min += get_grid().get_grid_size_z() # Updating z min because Up updated
	elif dir == 1: _y_min -= get_grid().get_grid_size_y() # Updating y min because North updated
	elif dir == 2: _x_max += get_grid().get_grid_size_x() # Updating x max because East updated
	elif dir == 4: _y_max += get_grid().get_grid_size_y() # Updating y max because South updated
	elif dir == 5: _x_min -= get_grid().get_grid_size_x() # Updating x min because West updated
	
	process_connect_tiles() # Starting connection processing
	reset_fail_safe() # Resetting fail safe
	process_main(true) # Starting processing with the need searching for neighbours
