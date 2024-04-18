@tool
class_name DS_WFCGen
extends Node

@export_category("Wave Function Collapse")
var _index_start_tile: int
var _start_tile_type: int

# Data Properties
var _data_names: DS_FixedStringArray = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse_settings/data_names.tres")
var _data_checkboxes: DS_FixedCheckBoxFlagArray = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse_settings/data_checkboxes.tres")
var _data_noo: DS_NoO = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse_settings/data_noo.tres")

var _grid: DS_Grid
var _tiles_open: Array[DS_Tile]
var _tiles_closed: Array[DS_Tile]
var _tile_current: DS_Tile
var _common_blocks: Array[int] # For containing all the common blocks
var _all_blocks: Array[int] # For containing all cardinal blocks
var _all_sizes: Array[int] # For containing all cardinal sizes
var _all_pos: Array[int] # For containing all cardinal pos
var _blocks: Array[int]
var _temp_blocks: Array[int]
var _type_names: String
var _grid_pos_names: String
var _counter1:= -1
var _counter2:= -1
var _counter3:= -1
var _counter_method:= -1 # This counter is for methods ONLY
var _counter_warning:= -1 # This counter is for warnings ONLY
var _max_block_size:= -1 # For storing the size of max compare
var _max_block_pos:= -1 # For storing the pos of max compare
var _is_common:= false
var _rng = RandomNumberGenerator.new()
var _prob:= -1.0
var _prob_total:= -1.0

func _get_configuration_warnings():
	var warnings: Array[String]
	
	if get_child_count() == 0:
		warnings.append("WFC Gen: Please give a child containing the grid.")
	else:
		if _search_grid_child() == null:
			warnings.append("WFC Gen: No Grid found in children. Please give a child containing the grid.")
	
	return warnings

func _get_property_list():
	var properties = []

	_type_names = ""
	_counter1 = 0
	# Loop for loading up all the type names
	while _counter1 < _data_names.get_size():
		_type_names += (_data_names.get_element(_counter1) + 
			("," if _counter1 < _data_names.get_size() - 1 else ""))
		_counter1 += 1

	# Showing the names as enums
	properties.append({
		"name" : "_start_tile_type",
		"type" : TYPE_INT,
		"hint" : PROPERTY_HINT_ENUM,
		"hint_string" : _type_names
	})

	_grid = _search_grid_child()

	if _grid != null:
		_grid_pos_names = ""
		_counter1 = 0

		while _counter1 < _grid.get_size():
			_grid_pos_names += (str(_counter1) + ("," if _counter1 < _grid.get_size() - 1 else ""))
			_counter1 += 1

		# Showing the names as enums
		properties.append({
			"name" : "_index_start_tile",
			"type" : TYPE_INT,
			"hint" : PROPERTY_HINT_ENUM,
			"hint_string" : _grid_pos_names
		})

	return properties

## This method applies wave function collapse to the given grid.
func _ready() -> void:
	if !Engine.is_editor_hint(): # Condition for Play mode script ONLY
		_grid = _search_grid_child() # Setting the grid child
		_tiles_open.clear()
		_tiles_closed.clear()

		# Setting the starting tile
		_tile_current = _grid.get_tile(_index_start_tile)
		_tile_current.set_tile_type(_start_tile_type)

		_counter1 = 0

		# Loop for adding all the cardinal directions for process
		while _counter1 < _tile_current.get_cardinal_direction_size():
			if _tile_current.get_cardinal_direction(_counter1) != null:
				_tiles_open.append(
					_tile_current.get_cardinal_direction(_counter1)
					)
			_counter1 += 1
		
		_tiles_closed.append(_tile_current) # Closing the first processed tile
		
		# Loop for processing all the tiles
		while !_tiles_open.is_empty():
			_tile_current = _tiles_open.pop_front() # Getting next tile
			_counter1 = 0 # Cardinal Direction counter
			_common_blocks.clear() # Clearing previous data
			_all_blocks.clear() # Clearing previous data
			_all_sizes.clear() # Clearing previous data
			_all_pos.clear() # Clearing previous data
			_blocks.clear() # Clearing previous data
			_max_block_size = 0 # Clearing previous data
			_max_block_pos = -1 # Clearing previous data
			
			# Loop for going through all the cardinal directions
			while _counter1 < _tile_current.get_cardinal_direction_size():
				# Condition for finding a cardinal direction
				if _tile_current.get_cardinal_direction(_counter1) != null:
					if _tile_current.get_cardinal_direction(_counter1).get_tile_type() != -1:
						_blocks = get_types_array(
							_tile_current.get_cardinal_direction(_counter1).get_tile_type())
						_all_pos.append(_all_blocks.size())
						_all_sizes.append(_blocks.size())
						
						# Condition for setting the max element holder
						if _blocks.size() > _max_block_size:
							_max_block_size = _blocks.size() # Updating max size
							_max_block_pos = _all_blocks.size() # Updating element holder position

						_counter2 = 0
						# Loop for adding all the blocks in all block array
						while _counter2 < _blocks.size():
							_all_blocks.append(_blocks[_counter2])
							_counter2 += 1
				_counter1 += 1
			
			# Condition for ONLY one tile present
			if _all_pos.size() == 1:
				_common_blocks = _all_blocks.duplicate(true)
			else:
				_counter1 = 0

				# Loop for getting all the common types
				while _counter1 < _max_block_size:
					_is_common = true # Resetting to check if next block is common
					_counter2 = 0

					# Loop for going through all the types
					while _counter2 < _all_pos.size():
						if _all_pos[_counter2] != _max_block_pos: # Making sure NOT comparing with self
							_counter3 = 0

							# Loop for finding common type
							while _counter3 < _all_sizes[_counter2]:
								# Checking if common type found
								if _all_blocks[_max_block_pos + _counter1] == _all_blocks[_all_pos[_counter2] + _counter3]:
									break
								_counter3 += 1
							
							# Condition for NOT finding common type
							if _counter3 == _all_sizes[_counter2]:
								_is_common = false
								break # No further searching required
						_counter2 += 1
					
					if _is_common: # Condition for adding the common type
						_common_blocks.append(_all_blocks[_max_block_pos + _counter1])
					_counter1 += 1

			_prob = _rng.randf() # Getting probability value
			_prob_total = (1.0 / _common_blocks.size()) # Resetting to find the tile type

			_counter1 = 0

			# Loop for finding the correct tile type
			while _counter1 < _common_blocks.size():
				if _prob <= _prob_total: # Tile type found 
					break
				else: # Setting next tile type to be checked
					_prob_total += (1.0 / _common_blocks.size())
				_counter1 += 1

			_tile_current.set_tile_type(_common_blocks[_counter1]) # Setting the tile type for current tile

			_counter1 = 0

			# Loop for adding more tiles for processing
			while _counter1 < _tile_current.get_cardinal_direction_size():
				if _tile_current.get_cardinal_direction(_counter1) != null:
					# Checking if tile has NOT been processed
					if (!_tiles_closed.has(_tile_current.get_cardinal_direction(_counter1)) 
						&& !_tiles_open.has(_tile_current.get_cardinal_direction(_counter1))):
							_tiles_open.append(_tile_current.get_cardinal_direction(_counter1))
				
				_counter1 += 1
			
			_tiles_closed.append(_tile_current) # Tile done with processing

## This method gets all the type of a given block.
func get_types_array(index:int) -> Array[int]:
	_temp_blocks.clear()
	_counter_method = 0 # The counter is the pos index

	# Loop for finding types
	while _counter_method <= index:
		# Condition for type found
		if _data_checkboxes.get_element(index, _counter_method):
			_temp_blocks.append(_counter_method) # Adding type
		_counter_method += 1
	
	# Setting the next main block for check.
	# Alos _counter_method is now the main index
	_counter_method = index + 1

	# Loop for finding types
	while _counter_method <= _data_noo.get_value():
		# Condition for type found
		if _data_checkboxes.get_element(_counter_method, index):
			_temp_blocks.append(_counter_method)
		_counter_method += 1
	
	return _temp_blocks

## This method searches for the grid child.
func _search_grid_child() -> DS_Grid:
	_counter_warning = 0
	while _counter_warning < get_child_count():
		if get_child(_counter_warning).has_method("_is_grid"):
				return get_child(_counter_warning)
		_counter_warning += 1
	return null

func _to_string() -> String:
	print_rich(_grid.show_grid_index(_index_start_tile))
	return ""
