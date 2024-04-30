@tool
class_name DS_WFCGen
extends DS_BaseGen

@export_category("Wave Function Collapse")
var _index_start_tile: int
var _start_tile_type: int
@export var _is_reprocess:= false

var _tiles_open: Array[DS_Tile]
var _tile_current: DS_Tile
var _common_blocks: Array[int] # For containing all the common blocks
var _all_blocks: Array[int] # For containing all cardinal blocks
var _all_sizes: Array[int] # For containing all cardinal sizes
var _all_pos: Array[int] # For containing all cardinal pos
var _blocks: Array[int]
var _rules_indv: Array[int] # For containing current individual rules
var _tiles_failed: Array[DS_Tile] # For containing tiles that have failed, tile.type = -1
var _tile_type_stored: int # For storing the reprocessed's adj's tile type
var _type_names: String
var _grid_pos_names: String
var _counter1:= -1
var _counter2:= -1
var _counter3:= -1
var _counter_adj:= -1
var _opposite_cardinal:= -1 # Needed to find the opposite cardinal index to the current tile
var _counter_method:= -1 # This counter is for methods ONLY
var _max_block_size:= -1 # For storing the size of max compare
var _max_block_pos:= -1 # For storing the pos of max compare
var _is_common:= false
var _rng = RandomNumberGenerator.new()
var _prob:= -1.0
var _prob_total:= -1.0
var _is_found_tile = false # Checking to see if the right tile has been found
var _temp_tile_h: DS_Tile
var _temp_tile_v: DS_Tile

var _DELETE_ME:= 1.0
var _nuke_counter:= 0
var _DELETE_ME2:= 0

func _get_property_list():
	var properties = []

	_type_names = ""
	_counter1 = 0
	get_data().instansiate()
	
	# Loop for loading up all the tile type names
	while _counter1 <= get_data().get_wfc_number_of_tiles():
		_type_names += (get_data().get_wfc_tile_names()[_counter1] +
			("," if _counter1 < get_data().get_wfc_number_of_tiles()
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
	_DELETE_ME = Time.get_unix_time_from_system()
	# Setting the starting and first tile
	get_grid_tile(_index_start_tile).set_tile_type(_start_tile_type)

	_tiles_open.clear()
	_tiles_open.append(get_grid_tile(_index_start_tile))
	_counter1 = 0
	
	# Loop for processing all the tiles, Normal mode
	while !_tiles_open.is_empty():
		_tile_current = _tiles_open.pop_front() # Getting next tile
		
		# Condition to check if tile has NOT been processed
		if _tile_current.get_tile_type() == -1: # TODO: Check if this condition is necessary as the popped tile will ALWAYS be -1 because adjs added are all -1s
			_process_for_finding_rules(_tile_current) # Finding all the possible rules for the current tile
			_set_tile(_tile_current) # Setting a type to the tile in the grid

			if _is_reprocess: # Checking if reprocess is active
				if _tile_current.get_tile_type() == -1: # Checking if the tile have been failed to be set
					_tiles_failed.append(_tile_current) # Storing failed tile to be reprocessed later
			
		_counter1 = 0

		# Loop for adding more tiles for processing
		while _counter1 < _tile_current.get_cardinal_direction_size():
			if _tile_current.get_cardinal_direction(_counter1) != null:
				# Checking if tile has NOT been processed
				if (_tile_current.get_cardinal_direction(_counter1).get_tile_type() == -1
					&& !_tiles_open.has(_tile_current.get_cardinal_direction(_counter1))):
						_tiles_open.append(_tile_current.get_cardinal_direction(_counter1))

			_counter1 += 1
		
		_DELETE_ME2 += 1
	
	print(self)
	
	print("Number of fails found: ", _tiles_failed.size())
	
	# Loop for reprocessing failed tiles, Reprocess mode
	while !_tiles_failed.is_empty():
		_tile_current = _tiles_failed.pop_front() # Popping a tile to be reprocessed

		_counter_adj = 0
		while _counter_adj < _tile_current.get_cardinal_direction_size(): # Loop for finding a tile type for the failed tile
			if _tile_current.get_cardinal_direction(_counter_adj) != null: # Checking if the adj is NOT null
				_process_for_finding_rules(_tile_current.get_cardinal_direction(_counter_adj)) # Getting common rules for the adj tile
				_tile_type_stored = _tile_current.get_cardinal_direction(_counter_adj).get_tile_type() # Storing the adj's current tile type
				_common_blocks.erase(_tile_type_stored) # Removing the stored tile type rule
				_set_tile(_tile_current.get_cardinal_direction(_counter_adj)) # Setting the adj tile type
				
				# Checking if found a tile type for adj and if to start reprocessing the failed tile
				if _tile_current.get_cardinal_direction(_counter_adj).get_tile_type() != -1:
					_process_for_finding_rules(_tile_current) # Getting common rules for the failed current tile
					_set_tile(_tile_current) # Setting the failed current's tile type
				else: # Condition for NOT found a tile type for adj
					_tile_current.get_cardinal_direction(_counter_adj).set_tile_type(_tile_type_stored) # Resetting the adj's tile type to the stored tile type
				
				if _tile_current.get_tile_type() != -1: # Condition to check if a tile type is found
					print("Tile FIXED!")
					break # Tile type found, NO further search required
			
			_counter_adj += 1

	
	print("Finished Making Grid in : ", ((Time.get_unix_time_from_system() - _DELETE_ME)) * 1000, "ms, Nukes: ", _nuke_counter)

## This method finds all the neighbouring tile rules for the given tile.
func _find_all_neighbour_tile_rules(tile: DS_Tile) -> void:
	_all_blocks.clear() # Clearing previous data
	_blocks.clear() # Clearing previous data
	_all_sizes.clear() # Clearing previous data
	_all_pos.clear() # Clearing previous data
	_max_block_size = 0 # Clearing previous data
	_max_block_pos = -1 # Clearing previous data
	
	_counter1 = 0 # Cardinal Direction counter
	# Loop for going through all the cardinal directions
	while _counter1 < tile.get_cardinal_direction_size():
		# Condition for finding a cardinal direction
		if tile.get_cardinal_direction(_counter1) != null:
			if tile.get_cardinal_direction(_counter1).get_tile_type() != -1: # Condition for finding all neighbouring rules
				_blocks = get_data().get_wfc_tile_rules(
					tile.get_cardinal_direction(_counter1).get_tile_type())
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

## This method finds all the common rules.
func _find_common_rules() -> void:
	_common_blocks.clear() # Clearing previous data

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
	
	if _common_blocks.is_empty(): # No common found, adding all tile types
		_counter1 = 0
		
		while _counter1 <= get_data().get_wfc_number_of_tiles(): # Loop for adding all the tile types
			_common_blocks.append(_counter1)
			_counter1 += 1

## This method sets the current tile with a tile type.
func _set_tile(tile: DS_Tile) -> void:
	while(_common_blocks.size() != 0):
		_prob = _rng.randf() # Getting probability value
		_prob_total = (1.0 / _common_blocks.size()) # Resetting to find the tile type

		_counter1 = 0 # This counter acts as common block index

		# Loop for randomly selecting a tile type
		while _counter1 < _common_blocks.size():
			if _prob <= _prob_total: # Tile type found 
				break
			else: # Setting next tile type to be checked
				_prob_total += (1.0 / _common_blocks.size())
			_counter1 += 1
		
		if _is_set_tile(tile, _common_blocks[_counter1], 0): # Found a tile to set for the current tile
			tile.set_tile_type(_common_blocks[_counter1]) # Setting the tile type for current tile
			break # Stopping search as tile has been found
		else: # Found no tile, removing the currently processed tile
			_common_blocks.remove_at(_counter1)

## This method handles the process of setting a tile
func _is_set_tile(tile:DS_Tile, selected_tile:int, rot_value:int) -> bool:
	_counter2 = rot_value # This counter acts as number of rotation
	
	while _counter2 < tile.get_cardinal_direction_size(): # Loop for rotating the tile
		tile.set_tile_rotation_value(_counter2) # Setting the rotation of the tile
		_counter3 = 0 # This counter acts as cardinal/neighbour index

		while _counter3 < tile.get_cardinal_direction_size(): # Loop for finding individual rule matches
			if tile.get_cardinal_direction(_counter3) != null:
				if tile.get_cardinal_direction(_counter3).get_tile_type() != -1:
					
					# Storing the correct individual rules after tile rotation
					_rules_indv = get_data().get_wfc_tile_rules_individual(selected_tile, 
						tile.get_rotational_cardinal_index(_counter3))

					# Condition for NOT finding any matches so breaking the loop for the next shift
					if !_rules_indv.has(tile.get_cardinal_direction(_counter3).get_tile_type()):
						break
					else: # Condition to check if neighbour allows to set tile

						_rules_indv = get_data().get_wfc_tile_rules_individual(tile.get_cardinal_direction(_counter3).get_tile_type(),
						tile.get_cardinal_direction(_counter3) # The neighbour's rotational cardinal index
						.get_rotational_cardinal_index(
							(_counter3 + 2 if (_counter3 + 2) < tile.get_cardinal_direction_size() else _counter3 - 2)))

						# Condition for NOT finding any matches from the neighbour's side
						if !_rules_indv.has(selected_tile):
							break

			_counter3 += 1
		
		# Found a tile to set for the current tile
		if _counter3 == tile.get_cardinal_direction_size():
			return true

		_counter2 += 1
	
	return false

## Process for finding all the possible rules for the given tile.
func _process_for_finding_rules(tile:DS_Tile) -> void:
	_find_all_neighbour_tile_rules(tile) # Finding all the main tile rules

	# Condition for ONLY one tile present
	if _all_pos.size() == 1:
		_common_blocks = _all_blocks.duplicate(true)
	else:
		_find_common_rules() # Finding all the common rules

## This method gets the opposite index of the given cardinal index.
func _get_cardinal_opposite_index(index:int, size:int) -> int:
	return index + 2 if (index + 2) < size else index - 2

func _to_string() -> String:
	print_rich(_grid.show_grid_index_index(_index_start_tile))
	print("") # Next line
	print_rich(_grid.show_grid_tile_index(_index_start_tile))
	print("") # Next line
	print_rich(_grid.show_grid_tile_rot_index(_index_start_tile))
	return ""
