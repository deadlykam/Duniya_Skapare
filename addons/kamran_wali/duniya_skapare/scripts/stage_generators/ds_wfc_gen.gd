@tool
class_name DS_WFCGen
extends DS_BaseGen

@export_category("Wave Function Collapse")
var _index_start_tile: int
var _start_tile_type: int
## Enabling/Disabling the Reprocess node. Caution: It may be a bit taxing for performance depending on your rule sets.
@export var _is_reprocess:= false
## Enabling/Disabling the Influence node. Caution: It may be a bit taxing for performance depending on your rule sets.
@export var _is_influence:= false

var _tiles_open: Array[DS_Tile]
var _tiles_closed: Array[DS_Tile]
var _tile_current: DS_Tile
var _temp_rules: Array[int]
var _common_rules: Array[int] # For containing all the common blocks
var _influence_rules: Array[int] # For containing all the influence rules
var _all_blocks: Array[int] # For containing all cardinal blocks
var _all_sizes: Array[int] # For containing all cardinal sizes
var _all_pos: Array[int] # For containing all cardinal pos
var _blocks: Array[int]
var _rules_indv: Array[int] # For containing current individual rules
var _tiles_failed: Array[DS_Tile] # For containing tiles that have failed, tile.type = -1
var _tile_type_stored: int # For storing the reprocessed's adj's tile type
var _tile_rot_stored: int # For storing the reprocessed's adj's tile rot
var _type_names: String
var _grid_pos_names: String
var _counter1:= -1
var _counter2:= -1
var _counter3:= -1
var _counter4:= -1
var _counter_rule_1:= -1
var _counter_rule_2:= -1
var _counter_rule_3:= -1
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
var _DELETE_ME3:= 0

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

	if _is_reprocess: _tiles_failed.clear() # Clearing previous failed data
	_tiles_open.clear()
	_tiles_open.append(get_grid_tile(_index_start_tile))
	_counter1 = 0
	
	# Loop for processing all the tiles, Normal mode
	while !_tiles_open.is_empty():
		print("Tile ", _DELETE_ME2, ":")
		_tile_current = _tiles_open.pop_front() # Getting next tile
		
		# Condition to check if tile has NOT been processed
		if _tile_current.get_tile_type() == -1: # TODO: Check if this condition is necessary as the popped tile will ALWAYS be -1 because adjs added are all -1s
			_common_rules = _process_for_getting_rules(_tile_current) # Finding all the possible rules for the current tile
			_set_tile(_tile_current, _common_rules) # Setting a type to the tile in the grid

			if _is_reprocess: # Checking if reprocess is active
				if _tile_current.get_tile_type() == -1: # Checking if the tile have been failed to be set
					_tiles_failed.append(_tile_current) # Storing failed tile to be reprocessed later
			
		_counter1 = 0

		# Loop for adding more tiles for processing
		while _counter1 < _tile_current.get_cardinal_direction_size():
			if _tile_current.get_cardinal_direction(_counter1) != null:
				# Checking if tile has NOT been processed
				if (_tile_current.get_cardinal_direction(_counter1).get_tile_type() == -1
					&& !_tiles_open.has(_tile_current.get_cardinal_direction(_counter1))
					&& !_tiles_closed.has(_tile_current.get_cardinal_direction(_counter1))):
						_tiles_open.append(_tile_current.get_cardinal_direction(_counter1))

			_counter1 += 1
		
		_tiles_closed.append(_tile_current) # The current tile has been process
		_DELETE_ME2 += 1
	
	print("Before reprocess")
	print(self)
	
	print("Number of fails found: ", _tiles_failed.size())
	
	# Loop for reprocessing failed tiles, Reprocess mode
	while !_tiles_failed.is_empty():
		_tile_current = _tiles_failed.pop_front() # Popping a tile to be reprocessed

		_counter_adj = 0
		while _counter_adj < _tile_current.get_cardinal_direction_size(): # Loop for finding a tile type for the failed tile
			if _tile_current.get_cardinal_direction(_counter_adj) != null: # Checking if the adj is NOT null
				_tile_type_stored = _tile_current.get_cardinal_direction(_counter_adj).get_tile_type() # Storing the adj's tile type
				_tile_rot_stored = _tile_current.get_cardinal_direction(_counter_adj).get_tile_rotation_value() # Storing the adj's tile type
				
				# Rotation fix check
				if _tile_type_stored != -1: # Checking if the tile has a type
					if _is_set_tile(_tile_current.get_cardinal_direction(_counter_adj), _tile_type_stored, _tile_rot_stored + 1): # Checking if rotating the tile fixed the issue
						_common_rules = _process_for_getting_rules(_tile_current) # Getting common rules for the failed current tile
						_set_tile(_tile_current, _common_rules) # Setting the failed current's tile type

						if _tile_current.get_tile_type() != -1: # Condition to check if a tile type is found
							print("Rotation Fixed!")
							_DELETE_ME3 += 1
							break # Tile type found, NO further search required
					
				_common_rules = _process_for_getting_rules(_tile_current.get_cardinal_direction(_counter_adj)) # Getting common rules for the adj tile
				# _tile_type_stored = _tile_current.get_cardinal_direction(_counter_adj).get_tile_type() # Storing the adj's tile type
				# _tile_rot_stored = _tile_current.get_cardinal_direction(_counter_adj).get_tile_rotation_value() # Storing the adj's tile type
				_common_rules.erase(_tile_type_stored) # Removing the stored tile type rule
				_tile_current.get_cardinal_direction(_counter_adj).reset_tile() # Resetting the adj tile for reprocessing
				_set_tile(_tile_current.get_cardinal_direction(_counter_adj), _common_rules) # Setting the adj tile type
				
				# Checking if found a tile type for adj and if to start reprocessing the failed tile
				if _tile_current.get_cardinal_direction(_counter_adj).get_tile_type() != -1:
					_common_rules = _process_for_getting_rules(_tile_current) # Getting common rules for the failed current tile
					_set_tile(_tile_current, _common_rules) # Setting the failed current's tile type
				else: # Condition for NOT found a tile type for adj
					_tile_current.get_cardinal_direction(_counter_adj).set_tile_type(_tile_type_stored) # Resetting the adj's tile type to the stored tile type
					_tile_current.get_cardinal_direction(_counter_adj).set_tile_rotation_value(_tile_rot_stored) # Resetting the adj's tile rot value to the stored tile rot value
				
				if _tile_current.get_tile_type() != -1: # Condition to check if a tile type is found
					_DELETE_ME3 += 1
					break # Tile type found, NO further search required
			
			_counter_adj += 1

	print("Number of tiles fixed: ", _DELETE_ME3)	
	print("Finished Making Grid in : ", ((Time.get_unix_time_from_system() - _DELETE_ME)) * 1000, "ms, Nukes: ", _nuke_counter)

## This method finds all the neighbouring tile rules for the given tile.
func _find_all_neighbour_tile_rules(tile: DS_Tile) -> void:
	_all_blocks.clear() # Clearing previous data
	_blocks.clear() # Clearing previous data
	_all_sizes.clear() # Clearing previous data
	_all_pos.clear() # Clearing previous data
	_max_block_size = 0 # Clearing previous data
	_max_block_pos = -1 # Clearing previous data
	
	_counter_rule_1 = 0 # Cardinal Direction counter
	# Loop for going through all the cardinal directions
	while _counter_rule_1 < tile.get_cardinal_direction_size():
		# Condition for finding a cardinal direction
		if tile.get_cardinal_direction(_counter_rule_1) != null:
			if tile.get_cardinal_direction(_counter_rule_1).get_tile_type() != -1: # Condition for finding all neighbouring rules
				_blocks = get_data().get_wfc_tile_rules(
					tile.get_cardinal_direction(_counter_rule_1).get_tile_type())
				_all_pos.append(_all_blocks.size())
				_all_sizes.append(_blocks.size())
				
				# Condition for setting the max element holder
				if _blocks.size() > _max_block_size:
					_max_block_size = _blocks.size() # Updating max size
					_max_block_pos = _all_blocks.size() # Updating element holder position

				_counter_rule_2 = 0
				# Loop for adding all the blocks in all block array
				while _counter_rule_2 < _blocks.size():
					_all_blocks.append(_blocks[_counter_rule_2])
					_counter_rule_2 += 1
		_counter_rule_1 += 1

## This method finds all the common rules.
func _find_common_rules() -> void:
	_temp_rules.clear() # Clearing previous data

	_counter_rule_1 = 0

	# Loop for getting all the common types
	while _counter_rule_1 < _max_block_size:
		_is_common = true # Resetting to check if next block is common
		_counter_rule_2 = 0

		# Loop for going through all the types
		while _counter_rule_2 < _all_pos.size():
			if _all_pos[_counter_rule_2] != _max_block_pos: # Making sure NOT comparing with self
				_counter_rule_3 = 0

				# Loop for finding common type
				while _counter_rule_3 < _all_sizes[_counter_rule_2]:
					# Checking if common type found
					if _all_blocks[_max_block_pos + _counter_rule_1] == _all_blocks[_all_pos[_counter_rule_2] + _counter_rule_3]:
						break
					_counter_rule_3 += 1
				
				# Condition for NOT finding common type
				if _counter_rule_3 == _all_sizes[_counter_rule_2]:
					_is_common = false
					break # No further searching required
			_counter_rule_2 += 1
		
		if _is_common: # Condition for adding the common type
			_temp_rules.append(_all_blocks[_max_block_pos + _counter_rule_1])
		_counter_rule_1 += 1
	
	if _temp_rules.is_empty(): # No common found, adding all tile types
		_counter_rule_1 = 0
		
		while _counter_rule_1 <= get_data().get_wfc_number_of_tiles(): # Loop for adding all the tile types
			_temp_rules.append(_counter_rule_1)
			_counter_rule_1 += 1
	
	return _temp_rules.duplicate()

## This method sets the current tile with a tile type.
func _set_tile(tile: DS_Tile, rules: Array[int]) -> void:
	while(rules.size() != 0):
		_prob = _rng.randf() # Getting probability value
		_prob_total = (1.0 / rules.size()) # Resetting to find the tile type

		_counter1 = 0 # This counter acts as common block index

		# Loop for randomly selecting a tile type
		while _counter1 < rules.size():
			if _prob <= _prob_total: # Tile type found 
				break
			else: # Setting next tile type to be checked
				_prob_total += (1.0 / rules.size())
			_counter1 += 1
		
		if _is_set_tile(tile, rules[_counter1], 0): # Found a tile to set for the current tile
			tile.set_tile_type(rules[_counter1]) # Setting the tile type for current tile
			break # Stopping search as tile has been found
		else: # Found no tile, removing the currently processed tile
			rules.remove_at(_counter1)

## This method handles the process of setting a tile
func _is_set_tile(tile:DS_Tile, selected_tile:int, rot_value:int) -> bool:
	_counter2 = rot_value # This counter acts as number of rotation
	
	while _counter2 < tile.get_cardinal_direction_size(): # Loop for rotating the tile
		tile.set_tile_rotation_value(_counter2) # Setting the rotation of the tile
		_counter3 = 0 # This counter acts as cardinal/neighbour index

		while _counter3 < tile.get_cardinal_direction_size(): # Loop for finding individual rule matches
			if tile.get_cardinal_direction(_counter3) != null:
				if tile.get_cardinal_direction(_counter3).get_tile_type() != -1: # Checking if neighbour tile has been set
					
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
				else: # Neighbour tile has NOT been set
					if _is_influence: # Checking if influence has been enabled
						_influence_rules = _process_for_getting_rules(tile.get_cardinal_direction(_counter3))
						if !_influence_rules.is_empty():
							# Storing the correct individual rules after tile rotation
							_rules_indv = get_data().get_wfc_tile_rules_individual(selected_tile, 
								tile.get_rotational_cardinal_index(_counter3))
							
							_counter4 = 0
							while _counter4 < _influence_rules.size(): # Loop for checking if there is a match between influence tile and selected tile
								if _rules_indv.has(_influence_rules[_counter4]): # Match found breaking loop
									break
								_counter4 += 1
							
							if _counter4 == _influence_rules.size(): # Condition for NOT finding a match and thus breaking the loop
								break # Breaking the loop because a match has NOT been found
				
			_counter3 += 1
		
		# Found a tile to set for the current tile
		if _counter3 == tile.get_cardinal_direction_size():
			return true

		_counter2 += 1
	
	return false

## Process for finding all the possible rules for the given tile and returning the common rule array
func _process_for_getting_rules(tile:DS_Tile) -> Array[int]:
	_find_all_neighbour_tile_rules(tile) # Finding all the main tile rules

	# Condition for ONLY one tile present
	if _all_pos.size() == 1:
		_temp_rules = _all_blocks.duplicate(true)
	else:
		_find_common_rules() # Finding all the common rules
	
	return _temp_rules.duplicate()

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
