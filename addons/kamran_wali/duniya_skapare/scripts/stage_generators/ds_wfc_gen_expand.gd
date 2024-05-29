@tool
extends "res://addons/kamran_wali/duniya_skapare/scripts/stage_generators/ds_wfc_base_continuous.gd"

# Properties for internal usage ONLY
var _tile_new: DS_Tile
var _x_min:= -1
var _x_max:= -1
var _y_min:= -1
var _y_max:= -1
var _z_min:= -1
# var _z_max:= -1
var _c_x:= -1
var _c_y:= -1
var _c_z:= -1

func setup() -> void:
	super()
	_x_min = 0
	_x_max = get_grid().get_grid_size_x()
	_y_min = 0
	_y_max = get_grid().get_grid_size_y()
	_z_min = get_grid().get_grid_size_z()
	# _z_max = get_grid().get_grid_size_z()

func expand_grid(dir:int) -> void:
	# TODO: First do for North only.
	# TODO: Get the minimum x and y coordinates for North
	# TODO: When expanding north subtract from y min value
	set_processing(true) # Starting processing
	start_debug_timer() # Starting the debug timer

	# if dir == 1:
	# 	# NORTH
	# 	_c_z = 0
	# 	while _c_z <= _z_min: # Loop for going through z coordinates
	# 		_c_y = _y_min - 1 # Starting from new coordinates
	# 		while _c_y > _y_min - get_grid().get_grid_size_y() - 1: # Loop for going through y coordinates
	# 			_c_x = _x_min
	# 			while _c_x < _x_max: # Loop for going through x coordinates
	# 				_tile_new = DS_Tile.new() # Creating a new tile
	# 				_tile_new.set_coord(_c_x, _c_y, _c_z) # Setting new tile's coordinates
	# 				get_grid().add_tile(_tile_new) # Adding new tile to the main grid
	# 				add_tile_to_connect(_tile_new) # Adding tile to connection processing
	# 				add_tile_to_process(_tile_new) # Adding tile to main processing
	# 				_c_x += 1
	# 			_c_y -= 1
	# 		_c_z += 1
	# 	_y_min -= get_grid().get_grid_size_y() # Updating y min
	
	# if dir == 4:
	# 	# SOUTH
	# 	_c_z = 0
	# 	while _c_z <= _z_min: # Loop for going through z coordinates
	# 		_c_y = _y_max # Starting from new coordinates
	# 		while _c_y < _y_max + get_grid().get_grid_size_y(): # Loop for going through y coordinates
	# 			_c_x = _x_min
	# 			while _c_x < _x_max: # Loop for going through x coordinates
	# 				_tile_new = DS_Tile.new() # Creating a new tile
	# 				_tile_new.set_coord(_c_x, _c_y, _c_z) # Setting new tile's coordinates
	# 				get_grid().add_tile(_tile_new) # Adding new tile to the main grid
	# 				add_tile_to_connect(_tile_new) # Adding tile to connection processing
	# 				add_tile_to_process(_tile_new) # Adding tile to main processing
	# 				_c_x += 1
	# 			_c_y += 1
	# 		_c_z += 1
	# 	_y_max += get_grid().get_grid_size_y() # Updating y max
	
	# if dir == 5:
	# 	# WEST
	# 	_c_z = 0
	# 	while _c_z <= _z_min:
	# 		_c_y = _y_min
	# 		while _c_y < _y_max:
	# 			_c_x = _x_min - 1
	# 			while _c_x > _x_min - get_grid().get_grid_size_x() - 1:
	# 				_tile_new = DS_Tile.new() # Creating a new tile
	# 				_tile_new.set_coord(_c_x, _c_y, _c_z) # Setting new tile's coordinates
	# 				get_grid().add_tile(_tile_new) # Adding new tile to the main grid
	# 				add_tile_to_connect(_tile_new) # Adding tile to connection processing
	# 				add_tile_to_process(_tile_new) # Adding tile to main processing
	# 				_c_x -= 1
	# 			_c_y += 1
	# 		_c_z += 1
	# 	_x_min -= get_grid().get_grid_size_x()
	
	# if dir == 2:
	# 	# EAST
	# 	_c_z = 0
	# 	while _c_z <= _z_min:
	# 		_c_y = _y_min
	# 		while _c_y < _y_max:
	# 			_c_x = _x_max
	# 			while _c_x < _x_max + get_grid().get_grid_size_x():
	# 				_tile_new = DS_Tile.new() # Creating a new tile
	# 				_tile_new.set_coord(_c_x, _c_y, _c_z) # Setting new tile's coordinates
	# 				get_grid().add_tile(_tile_new) # Adding new tile to the main grid
	# 				add_tile_to_connect(_tile_new) # Adding tile to connection processing
	# 				add_tile_to_process(_tile_new) # Adding tile to main processing
	# 				_c_x += 1
	# 			_c_y += 1
	# 		_c_z += 1
	# 	_x_max += get_grid().get_grid_size_x()
	
	# if dir == 0:
	# 	# UP
	# 	_c_z = _z_min + 1
	# 	while _c_z <= _z_min + get_grid().get_grid_size_z():
	# 		_c_y = _y_min
	# 		while _c_y < _y_max:
	# 			_c_x = _x_min
	# 			while _c_x < _x_max:
	# 				_tile_new = DS_Tile.new() # Creating a new tile
	# 				_tile_new.set_coord(_c_x, _c_y, _c_z) # Setting new tile's coordinates
	# 				get_grid().add_tile(_tile_new) # Adding new tile to the main grid
	# 				add_tile_to_connect(_tile_new) # Adding tile to connection processing
	# 				add_tile_to_process(_tile_new) # Adding tile to main processing
	# 				_x_max += 1
	# 			_c_y += 1
	# 		_c_z += 1
	# 	_z_min += get_grid().get_grid_size_z()
	
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
				add_tile_to_process(_tile_new) # Adding tile to main processing
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
	process_main(false) # Starting processing without the need searching for neighbours
