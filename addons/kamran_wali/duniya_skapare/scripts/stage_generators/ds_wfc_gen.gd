@tool
class_name DS_WFCGen
extends DS_BaseGen

@export_category("Wave Function Collapse")
var _index_start_tile: int
var _start_tile_type: int

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
var _max_block_size:= -1 # For storing the size of max compare
var _max_block_pos:= -1 # For storing the pos of max compare
var _is_common:= false
var _rng = RandomNumberGenerator.new()
var _prob:= -1.0
var _prob_total:= -1.0

func _get_property_list():
	var properties = []

	_type_names = ""
	_counter1 = 0
	# Loop for loading up all the tile type names
	while _counter1 <= DS_Data.get_instance().get_wfc_number_of_tiles():
		_type_names += (DS_Data.get_instance().get_wfc_tile_names()[_counter1] +
			("," if _counter1 < DS_Data.get_instance().get_wfc_number_of_tiles()
			else ""))
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

func _setup() -> void:
	# Setting the starting and first tile
	_grid.get_tile(_index_start_tile).set_tile_type(_start_tile_type)

	_tiles_open.clear()
	_tiles_closed.clear()
	_tiles_open.append(_grid.get_tile(_index_start_tile))
	_counter1 = 0
	
	# Loop for processing all the tiles
	while !_tiles_open.is_empty():
		_tile_current = _tiles_open.pop_front() # Getting next tile
		_common_blocks.clear() # Clearing previous data
		_all_blocks.clear() # Clearing previous data
		_all_sizes.clear() # Clearing previous data
		_all_pos.clear() # Clearing previous data
		_blocks.clear() # Clearing previous data
		_max_block_size = 0 # Clearing previous data
		_max_block_pos = -1 # Clearing previous data
		_counter1 = 0 # Cardinal Direction counter
		
		# Condition to check if tile has NOT been processed
		if _tile_current.get_tile_type() == -1:
			# Loop for going through all the cardinal directions
			while _counter1 < _tile_current.get_cardinal_direction_size():
				# Condition for finding a cardinal direction
				if _tile_current.get_cardinal_direction(_counter1) != null:
					if _tile_current.get_cardinal_direction(_counter1).get_tile_type() != -1:
						_blocks = DS_Data.get_instance().get_wfc_tile_rules(
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

func _to_string() -> String:
	print_rich(_grid.show_grid_index_index(_index_start_tile))
	print("") # Next line
	print_rich(_grid.show_grid_tile_index(_index_start_tile))
	return ""