@tool
class_name DS_WFCGen
extends DS_BaseGen

@export_category("Wave Function Collapse")
var _index_start_tile: int
var _start_tile_type: int
@export var _is_future_check:= false
@export var _is_nuke:= false
@export var _nuke_radius:= 1 # TODO: DO NOT ALLOW BELOW 1 VALUES

var _tiles_open: Array[DS_Tile]
var _tiles_closed: Array[DS_Tile]
var _tiles_nuked: Array[DS_Tile]
var _tile_current: DS_Tile
var _common_blocks: Array[int] # For containing all the common blocks
var _all_blocks: Array[int] # For containing all cardinal blocks
var _all_sizes: Array[int] # For containing all cardinal sizes
var _all_pos: Array[int] # For containing all cardinal pos
var _blocks: Array[int]
var _rules_indv: Array[int] # For containing current individual rules
var _rules_indv_fc: Array[int] # For containing future check individual rules
var _type_names: String
var _grid_pos_names: String
var _counter1:= -1
var _counter2:= -1
var _counter3:= -1
var _counter4:= -1
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
	_tiles_closed.clear()
	_tiles_open.append(get_grid_tile(_index_start_tile))
	_counter1 = 0
	
	# Loop for processing all the tiles
	while !_tiles_open.is_empty():
		print("Tile ", _DELETE_ME2, ": ")
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
				if (_tile_current.get_cardinal_direction(_counter1).get_tile_type() == -1
					&& !_tiles_open.has(_tile_current.get_cardinal_direction(_counter1))):
						_tiles_open.append(_tile_current.get_cardinal_direction(_counter1))

			_counter1 += 1
		
		_DELETE_ME2 += 1
		
		# # Loop for adding more tiles for processing
		# while _counter1 < _tile_current.get_cardinal_direction_size():
		# 	if _tile_current.get_cardinal_direction(_counter1) != null:
		# 		# Checking if tile has NOT been processed
		# 		if (!_tiles_closed.has(_tile_current.get_cardinal_direction(_counter1)) 
		# 			&& !_tiles_open.has(_tile_current.get_cardinal_direction(_counter1))):
		# 				_tiles_open.append(_tile_current.get_cardinal_direction(_counter1))
			
		# 	_counter1 += 1

		# # TODO: See if this works with and without Nuke mode
		# if _is_nuke && _tile_current.get_tile_type() != -1: # Checking if to allow to close the tile during nuke mode
		# 	_tiles_closed.append(_tile_current) # Tile done with processing
		# elif !_is_nuke: # Normal mode
		# 	_tiles_closed.append(_tile_current) # Tile done with processing
	
	print("Finished Making Grid in : ", ((Time.get_unix_time_from_system() - _DELETE_ME)) * 1000, "ms, Nukes: ", _nuke_counter)

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
	
	if _common_blocks.is_empty(): # No common found, adding all tile types
		_counter1 = 0
		
		while _counter1 <= get_data().get_wfc_number_of_tiles(): # Loop for adding all the tile types
			_common_blocks.append(_counter1)
			_counter1 += 1

## This method sets the current tile with a tile type.
func _set_tile() -> void:
	while(_common_blocks.size() != 0):
		print("Common Blocks: ", _common_blocks)
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

		print("Selected Block: ", _common_blocks[_counter1])
		
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

						# Condition for NOT finding any matches so breaking the loop for the next shift
						if !_rules_indv.has(_tile_current.get_cardinal_direction(_counter3).get_tile_type()):
							break
						else: # Condition to check if neighbour allows to set tile

							_rules_indv = get_data().get_wfc_tile_rules_individual(_tile_current.get_cardinal_direction(_counter3).get_tile_type(),
							_tile_current.get_cardinal_direction(_counter3) # The neighbour's rotational cardinal index
							.get_rotational_cardinal_index(
								(_counter3 + 2 if (_counter3 + 2) < _tile_current.get_cardinal_direction_size() else _counter3 - 2)))

							# Condition for NOT finding any matches from the neighbour's side
							if !_rules_indv.has(_common_blocks[_counter1]):
								break

				_counter3 += 1
			
			# Found a tile to set for the current tile
			if _counter3 == _tile_current.get_cardinal_direction_size():
				_is_found_tile = true
				break

			_counter2 += 1

		if _is_found_tile: # Found a tile to set for the current tile
			# TODO: Do the future tile check here. If tile found after that then it is ok. If NO tile found then I guess
			#		that should be considered as weak rules. But also use nuke with future tile check to see what happens
			_tile_current.set_tile_type(_common_blocks[_counter1]) # Setting the tile type for current tile
			
			if _is_future_check: # Checking if future check is enabled
				_future_check() # Doing future check process
				if _tile_current.get_tile_type() != -1: # Future check approved for tile set
					print("- Future Check Approved!")
					break
				else: # Future check denied for tile set
					print("- Future Check Denied!")
					# TODO: Reprocess the previous tile to find a better fit or a better tile
					_common_blocks.remove_at(_counter1)
			else:
				break # Stopping search as tile has been found

		else: # Found no tile, removing the currently processed tile
			_common_blocks.remove_at(_counter1)
	
	if _is_nuke: # Checking if nuke option is available
		if _common_blocks.is_empty(): # Checking if nuking required
			# TODO: Store the failed tile in the failed tiled array and once the whole grid has been set only then
			#		process each failed tile one at a time
			_nuke_process(_tile_current)
			_nuke_counter += 1

## This method handles the nuking process of the correct tiles
func _nuke_process(tile:DS_Tile) -> void:
	_tiles_nuked.clear()
	_counter1 = _nuke_radius * 2 # Getting the correct counter

	while _counter1 >= 0: # Loop for finding East and West tiles to nuke
		if _counter1 > _nuke_radius: # East
			_temp_tile_h = _get_adj_neighbour_counter(tile, 1, _counter1 - _nuke_radius)
		elif _counter1 == _nuke_radius: # Mid
			_temp_tile_h = tile
		elif _counter1 < _nuke_radius: # West
			_temp_tile_h = _get_adj_neighbour_counter(tile, 3, _nuke_radius - _counter1)
		
		if _temp_tile_h != null:
			_counter2 = _nuke_radius * 2
			while _counter2 >= 0: # Loop for finding South an North tiles to nuke
				if _counter2 > _nuke_radius: # South
					_temp_tile_v = _get_adj_neighbour_counter(_temp_tile_h, 2, _counter2 - _nuke_radius)
				elif _counter2 == _nuke_radius: # Mid
					_temp_tile_v = _temp_tile_h
				elif _counter2 < _nuke_radius: # North
					_temp_tile_v = _get_adj_neighbour_counter(_temp_tile_h, 0, _nuke_radius - _counter)
				
				if _temp_tile_v != null: # Condition for nuking the tile
					_nuke_tile(_temp_tile_v)
				
				if _counter1 == _nuke_radius && _counter2 == _nuke_radius: # Condition to add the tile being nuked to be processed
					if !_tiles_open.has(_temp_tile_v): # Checking if it is NOT added already
						_temp_tile_v.reset_tile()
						# _tiles_open.push_front(_temp_tile_v)
						_tiles_nuked.append(tile)
				_counter2 -= 1
		_counter1 -= 1
	
	_counter1 = 0
	while _counter1 < _tiles_nuked.size(): # Loop for finding first tile with a neighbour typed tile
		_counter2 = 0
		while _counter2 < _tiles_nuked[_counter1].get_cardinal_direction_size(): # Loop for checking all directions
			if _tiles_nuked[_counter1].get_cardinal_direction(_counter2) != null:
				if _tiles_nuked[_counter1].get_cardinal_direction(_counter2).get_tile_type() != -1: # Condition for finding a typed neighbour
					if !_tiles_open.has(_tiles_nuked[_counter1]): # Is already NOT added to open list
						_tiles_open.append(_tiles_nuked[_counter1])
					break # Breaking when added or already added
			_counter2 += 1

			if _counter2 != _tiles_nuked[_counter1].get_cardinal_direction_size(): # Found a typed neighbour NO more search required
				break
		_counter1 += 1
	
	# _counter1 = 0
	# while _counter1 < _tiles_nuked.size(): # Loop for finding first tile with a neighbour typed tile
	# 	_counter2 = 0
	# 	while _counter2 < _tiles_nuked[_counter1].get_cardinal_direction_size(): # Loop for checking all directions
	# 		if _tiles_nuked[_counter1].get_cardinal_direction(_counter2) != null:
	# 			if _tiles_nuked[_counter1].get_cardinal_direction(_counter2).get_tile_type() != -1: # Condition for finding a typed neighbour
	# 				_tiles_open.append(_tiles_nuked[_counter1])
	# 				break
	# 		_counter2 += 1

	# 		if _counter2 != _tiles_nuked[_counter1].get_cardinal_direction_size(): # Found a typed neighbour NO more search required
	# 			break
	# 	_counter1 += 1

## This method nukes the given tile.
func _nuke_tile(tile:DS_Tile) -> void:
	if tile != null: # Checking if tile is NOT null
		if tile.get_tile_type() != -1 && tile != get_grid_tile(_index_start_tile): # Checking tile has been set and NOT starting tile
			_counter_method = 0
			while _counter_method < get_update_tile_info().size(): # Loop for checking if tile is NOT any of the set tiles
				# Condition to check if tile is a set tile
				if tile == get_grid_tile(get_update_tile_info()[_counter_method].get_index()):
					break
				_counter_method += 1
			
			# Condition to nuke the tile
			if _counter_method == get_update_tile_info().size():
				tile.reset_tile()
				# _tiles_open.push_front(tile)
				# _tiles_closed.erase(tile)
				_tiles_nuked.append(tile)

func _future_check() -> void:
	print("- Started future check")
	_counter2 = 0 # Current tiles cardinal counter
	while _counter2 < _tile_current.get_cardinal_direction_size():
		if _tile_current.get_cardinal_direction(_counter2) != null: # Checking if has cardinal direction
			print("- NOT null, dir[",_counter2,"]: ", _tile_current.get_cardinal_direction(_counter2).get_tile_type())
			if _tile_current.get_cardinal_direction(_counter2).get_tile_type() == -1: # Checking if cardinal direction NOT placed yet
				print("- Is -1")
				_rules_indv = get_data().get_wfc_tile_rules_individual(_tile_current.get_tile_type(), # Storing current tile rules
					_tile_current.get_rotational_cardinal_index(_counter2))
				print("-Future Rules To Check:")
				
				_counter3 = 0 # Future tile cardinal counter
				while _counter3 < _tile_current.get_cardinal_direction(_counter2).get_cardinal_direction_size(): # Loop for getting the future tiles individual rules
					if _tile_current.get_cardinal_direction(_counter2).get_cardinal_direction(_counter3) != null:
						if _tile_current.get_cardinal_direction(_counter2).get_cardinal_direction(_counter3).get_tile_type() != -1:
							_rules_indv_fc = get_data().get_wfc_tile_rules_individual(
								_tile_current.get_cardinal_direction(_counter2).get_cardinal_direction(_counter3).get_tile_type(),
									_tile_current.get_cardinal_direction(_counter2).get_cardinal_direction(_counter3).get_rotational_cardinal_index(
										_get_cardinal_opposite_index(_counter3, 
										_tile_current.get_cardinal_direction(_counter2).get_cardinal_direction(_counter3)
											.get_cardinal_direction_size()) # Getting the future check individual rules
									))
							print("-- Current Tile Rules[", _counter2,"]: ", _rules_indv)
							print("-- Future Tile Rules[", _counter3,"]: ", _rules_indv_fc)

							_counter4 = 0
							while _counter4 < _rules_indv_fc.size(): # Loop for finding common rules
								if _rules_indv.has(_rules_indv_fc[_counter4]): # Condition for common rules found
									print("-- Indiv matching rules found")
									break
								_counter4 += 1
							
							if _counter4 == _rules_indv_fc.size(): # Condition for NOT finding matching rules
								print("-- No indiv matching rules found")
								break
					_counter3 += 1

				# No matching rules found from previous process
				if _counter3 != _tile_current.get_cardinal_direction(_counter2).get_cardinal_direction_size():
					print("-- No matching rules found")
					break
		_counter2 += 1
	
	if _counter2 != _tile_current.get_cardinal_direction_size(): # Current tile will NOT fit
		print("-- Tile type not fit for placement.")
		_tile_current.reset_tile() # Resetting tile
	
	print("- Ended future check")

## This method gets the adjacent neighbour by using the counter.
func _get_adj_neighbour_counter(tile:DS_Tile, dir:int, counter:int) -> DS_Tile:
	_counter_method = 0
	while _counter_method < counter: # Loop for finding adj neighbour
		if tile.get_cardinal_direction(dir) != null: # Check if has neighbour
			tile = tile.get_cardinal_direction(dir) # Getting neighbour
		else: # Neighbour NOT found
			tile = null
			break
		_counter_method += 1
	return tile

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
