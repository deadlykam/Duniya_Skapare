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
# var _rules_indv_cardinals: Array[int] # For containing the cardinals' individual rules
var _rules_indv: Array[int] # For containing current individual rules
var _type_names: String
var _grid_pos_names: String
var _counter1:= -1
var _counter2:= -1
var _counter3:= -1
var _opposite_cardinal:= -1 # Needed to find the opposite cardinal index to the current tile
var _counter_method:= -1 # This counter is for methods ONLY
var _max_block_size:= -1 # For storing the size of max compare
var _max_block_pos:= -1 # For storing the pos of max compare
var _is_common:= false
var _rng = RandomNumberGenerator.new()
var _prob:= -1.0
var _prob_total:= -1.0
var _is_found_tile = false # Checking to see if the right tile has been found

func _get_property_list():
	var properties = []

	_type_names = ""
	_counter1 = 0
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
		
		# Condition to check if tile has NOT been processed
		if _tile_current.get_tile_type() == -1:
			_find_all_neighbour_tile_rules() # Finding all the main tile rules
			
			# Condition for ONLY one tile present
			if _all_pos.size() == 1:
				_common_blocks = _all_blocks.duplicate(true)
			else:
				_find_common_rules() # Finding all the common rules

			_set_tile() # Adding a new tile to the grid

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

## This method finds all the neighbouring tile rules.
func _find_all_neighbour_tile_rules() -> void:
	_counter1 = 0 # Cardinal Direction counter
	# Loop for going through all the cardinal directions
	while _counter1 < _tile_current.get_cardinal_direction_size():
		# Condition for finding a cardinal direction
		if _tile_current.get_cardinal_direction(_counter1) != null:
			if _tile_current.get_cardinal_direction(_counter1).get_tile_type() != -1: # Condition for finding all neighbouring rules
				_blocks = get_data().get_wfc_tile_rules(
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

## This method finds all the common rules.
func _find_common_rules() -> void:
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

var _DELETE_ME:= 1 # REMOVE THIS VARIABLE AS IT IS FOR DEBUGGING ONLY!!! <-- !***

## This method sets the current tile with a tile type.
func _set_tile() -> void:
	print("Setting ", _DELETE_ME," Tile:")
	while(_common_blocks.size() != 0):
		print("- Tile Type Available: [", _common_blocks,"]")
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

		print("- Tile Type Randomly Selected: ", _common_blocks[_counter1])

		_counter2 = 0 # This counter acts as number of rotation
		_is_found_tile = false # Resetting found tile

		while _counter2 < _tile_current.get_cardinal_direction_size(): # Loop for rotating the tile
			_tile_current.set_tile_rotation_value(_counter2) # Setting the rotation of the tile
			_counter3 = 0 # This counter acts as cardinal/neighbour index

			while _counter3 < _tile_current.get_cardinal_direction_size(): # Loop for finding individual rule matches
				if _tile_current.get_cardinal_direction(_counter3) != null:
					if _tile_current.get_cardinal_direction(_counter3).get_tile_type() != -1:
						
						# Storing the correct individual rules after tile rotation
						_rules_indv = get_data().get_wfc_tile_rules_individual(_common_blocks[_counter1], 
							_tile_current.get_rotational_cardinal_index(_counter3))

						print("- Shift Rules[", _tile_current.get_rotational_cardinal_index(_counter3), "]: ", _rules_indv, ", N. Rule: ", 
						_tile_current.get_cardinal_direction(_counter3).get_tile_type(), ", C2: ", _counter2, ", C3: ", _counter3)

						# Condition for NOT finding any matches so breaking the loop for the next shift
						if !_rules_indv.has(_tile_current.get_cardinal_direction(_counter3).get_tile_type()):
							print("- No Matches found!")
							break
						else: # Condition to check if neighbour allows to set tile
							_rules_indv = get_data().get_wfc_tile_rules_individual(_tile_current.get_cardinal_direction(_counter3).get_tile_type(), 
							(_counter3 + 2 if (_counter3 + 2) < _tile_current.get_cardinal_direction_size() else _counter3 - 2))

							# Condition for NOT finding any matches from the neighbour's side
							if !_rules_indv.has(_common_blocks[_counter1]):
								print("- No Matches found in neighbour's check!")
								break
							
						# _rules_indv_cardinals.clear()
						# _rules_indv_current.clear()
						
						# # TODO: Check from here why the individual rules are not working especially the east side of coast
						# #		should be water or other coast and NOT ground.
						
						# # Calculating the opposite cardinal index
						# _opposite_cardinal = (_counter3 + 2 if (_counter3 + 2) < _tile_current.get_cardinal_direction_size()
						# 	else _counter3 - 2)
						# # Getting the opposite cardinal individual rules
						# _rules_indv_cardinals = get_data().get_wfc_tile_rules_individual(
						# 	_tile_current.get_cardinal_direction(_counter3).get_tile_type(), _opposite_cardinal)
						# print("- Opposite Rules: ", _rules_indv_cardinals)
						
						# if _rules_indv_cardinals.size() > 0: # Checking if individual rules found
						# 	# Getting the correct individual rules by shifting cardinals by 1 which is taken as rotation
						# 	_rules_indv_current = get_data().get_wfc_tile_rules_individual(_common_blocks[_counter1], 
						# 		((_counter3 - _counter2) if (_counter3 - _counter2) >= 0 
						# 		else _tile_current.get_cardinal_direction_size() + (_counter3 - _counter2)))
						# 	print("- Shift Rules: ", _rules_indv_current)
							
						# 	_counter4 = 0
						# 	while _counter4 < _rules_indv_cardinals.size(): # Loop for finding matching rules
						# 		# Match found breaking the loop
						# 		if _rules_indv_current.has(_rules_indv_cardinals[_counter4]):
						# 			break
						# 		_counter4 += 1
							
						# 	# No matches found, stopping the loop and going for next shift check
						# 	if _counter4 == _rules_indv_cardinals.size():
						# 		print("- No Matches found!")
						# 		break
						# else: # No rules found, stopping the loop and going for next shift check
						# 	break
						
				_counter3 += 1
			
			# Found a tile to set for the current tile
			if _counter3 == _tile_current.get_cardinal_direction_size():
				_is_found_tile = true
				print("- Found Match at C2: ", _counter2)
				break

			_counter2 += 1

		if _is_found_tile: # Found a tile to set for the current tile
			print("- Found Tile Type: ", _common_blocks[_counter1])
			_tile_current.set_tile_type(_common_blocks[_counter1]) # Setting the tile type for current tile
			print("===XXX===")
			break
		else: # Found no tile, removing the currently processed tile
			_common_blocks.remove_at(_counter1)
		
		print("===XXX===")
	_DELETE_ME += 1

func _to_string() -> String:
	print_rich(_grid.show_grid_index_index(_index_start_tile))
	print("") # Next line
	print_rich(_grid.show_grid_tile_index(_index_start_tile))
	print("") # Next line
	print_rich(_grid.show_grid_tile_rot_index(_index_start_tile))
	return ""
