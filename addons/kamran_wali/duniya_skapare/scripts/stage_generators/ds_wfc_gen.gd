@tool
class_name DS_WFCGen
extends DS_BaseGen

@export_category("Wave Function Collapse")
@export var _data: DS_WFC_Data:
	set(p_data):
		if _data != p_data:
			_data = p_data
			update_configuration_warnings()

var _index_start_tile: int
@export var _is_debug: bool
@export_group("Nuke Properties")
@export var _nuke_range:= 3 # TODO: Make sure it is NOT below 1
@export var _nuke_limit:= -1 # TODO: Make sure it is NOT below -1

# Properties for internal usage ONLY
var _tiles_open: Array[DS_Tile]
var _tiles_closed: Array[DS_Tile]
var _tiles_search_open: Array[DS_Tile]
var _tiles_search_closed: Array[DS_Tile]
var _tile_current: DS_Tile
var _tile_error: DS_Tile
var _tile_search: DS_Tile
var _rules: Array[int] # Final rules
var _rng = RandomNumberGenerator.new()
var _prob:= -1.0
var _prob_total:= -1.0
var _temp_rules: Array[int]
var _temp: Array[int]
var _temp2: Array[int]
var _entropy:= -1
var _c1:= -1
var _c2:= -1
var _c_re1:= -1
var _c_rule1:= -1
var _c_rule2:= -1
var _c_process1:= -1
var _c_found1:= -1
var _c_success:= -1
var _c_success2:= -1
var _c_failed:= -1
var _c_search:= -1
var _type_stored:= -1
var _rot_stored:= -1
var _debug_time:= 1.0
var _debug_nuke_counter:= 0
var _is_processing:= false
var _DELETE_ME:= 50
var _DELETE_ME2:= -1
var _DELETE_ME3:= -1

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	warnings = super._get_configuration_warnings()
	
	if _data == null:
		warnings.append("Data: Please give a wave function collapse Data. it can NOT be null.")
	
	return warnings

func setup() -> void:
	_is_processing = true # Setting processing flag to true
	if _is_debug: _debug_time = Time.get_unix_time_from_system() # Condition for starting debug time

	if get_start_tiles().size() != 0: # Condition for setting the start tiles
		_index_start_tile = get_start_tiles()[0].get_index() # Setting the first tile type which is needed by debug
		_c1 = 0
		
		while _c1 < get_start_tiles().size(): # Loop for setting the starting tiles
			get_grid().get_tile(get_start_tiles()[_c1].get_index()).set_tile_type(get_start_tiles()[_c1].get_type()) # Setting type
			get_grid().get_tile(get_start_tiles()[_c1].get_index()).set_tile_rotation_value(get_start_tiles()[_c1].get_rot_value()) # Setting rot value
			get_grid().get_tile(get_start_tiles()[_c1].get_index()).set_is_fixed(get_start_tiles()[_c1].is_fixed()) # Setting fixed tile
			_tiles_open.append(get_grid().get_tile(get_start_tiles()[_c1].get_index())) # Adding the tile to be processed
			_c1 += 1
		
		# print(self)
	else:
		_index_start_tile = _rng.randi_range(0, get_grid().get_size() - 1) # Getting a random tile for start tile
		_tiles_open.append(get_grid().get_tile(_index_start_tile)) # Adding the first tile to be processed

	while true: # Loop for running the process using wave function collapse
		_process_grid() # Main process, using wave function collapse to process the grid
		if is_gen_success() || (_debug_nuke_counter >= _nuke_limit && _nuke_limit != -1): break # Condition for breaking processing loop
		else:
			_DELETE_ME = 50
			_add_failed_tiles() # Getting all the failed tiles to process again
			# print_rich("[color=yellow]Number of failed tiles found: ", _tiles_open.size(),"[/color]")
			# print_rich("[color=yellow]Number of failed tiles found: ", _tiles_open.size(),", ", _DELETE_ME_METHOD(),"[/color]")
			if _DELETE_ME2 == _tiles_open.size():
				_DELETE_ME3 += 1
				if _DELETE_ME3 == 50:
					print(self)
			else:
				_DELETE_ME2 = _tiles_open.size()
				_DELETE_ME3 = 0
		
		# TODO: Increment the loop counter here and check if the counter reached
	
	# while !_tiles_open.is_empty(): # Loop to process all the tiles using wave function collapse
	# 	_c1 = 0 # Index of the open tiles
	# 	_c2 = 0 # For storing the lowest entropy index
	# 	_entropy = -1

	# 	while _c1 < _tiles_open.size(): # Loop for finding the lowest entropy
	# 		_temp_rules = _get_rules(_tiles_open[_c1])

	# 		if _entropy == -1 || _temp_rules.size() < _entropy: # Condition for finding the lowest entropy
	# 			_c2 = _c1 # Storing the index of the lowest entropy
	# 			_entropy = _temp_rules.size() # Updating the entropy value
	# 			_rules = _temp_rules.duplicate() # Storing the lowest entropy rules

	# 		_c1 += 1
		
	# 	_tile_current = _tiles_open.pop_at(_c2) # Getting the lowest entropy tile

	# 	if _tile_current.get_tile_type() == -1: # Checking if tile NOT processed
	# 		_process_tile(_tile_current, _rules.duplicate()) # Processing the current tile
	# 		if _tile_current.get_tile_type() == -1: # Condition for storing failed tiles
	# 			if _tile_error == null: # Chekcing if NO error tiles found
	# 				_c1 = 0
	# 				while _c1 < _tile_current.get_edge_size(): # Loop for finding an error tile
	# 					if _is_tile_processed(_tile_current.get_edge(_c1)): # Condition for finding the first processed tile as error tile
	# 						_tile_error = _tile_current.get_edge(_c1) # Setting the error tile
	# 						break
	# 					_c1 += 1
				
	# 			_reprocess_tile() # Reprocessing to fix error
		
	# 	_c1 = 0

	# 	# Loop for adding more tiles for processing
	# 	while _c1 < _tile_current.get_edge_size():
	# 		if _tile_current.get_edge(_c1) != null:
	# 			# Checking if the tile has NOT been processed
	# 			if (_tile_current.get_edge(_c1).get_tile_type() == -1
	# 			&& !_tiles_open.has(_tile_current.get_edge(_c1))
	# 			&& !_tiles_closed.has(_tile_current.get_edge(_c1))):
	# 				_tiles_open.append(_tile_current.get_edge(_c1))
	# 		_c1 += 1
		
	# 	_tiles_closed.append(_tile_current) # The current tile has been processed
	
	if _is_debug: # Condition for showing the debug info
		_debug_time = ((Time.get_unix_time_from_system() - _debug_time) * 1000)
		print_rich("[color=purple]===WFC Result===[/color]")
		print("Run Time: ", _debug_time, "ms")
		if _debug_nuke_counter != 0: print_rich("[color=orange]Total nukes fired: ", _debug_nuke_counter, "[/color]")
		if is_gen_success(): print_rich("[color=green]Wave Function Collapse: Successful![/color]")
		else: print_rich("[color=red]Wave Function Collapse: Failed![/color]")
		_total_successful_tiles() # Finding all the successful tiles
		print_rich("[color=green]Tiles Succeeded: ", _c_success,"[/color], [color=red]Tiles Failed: ", 
			(get_grid().get_size() - _c_success), "[/color], Success Rate: ", ((float(_c_success) / float(get_grid().get_size())) * 100.0), "%")
		print_rich("[color=purple]===XXX===[/color]")

	_is_processing = false # Setting processing flag to false

func reset() -> void:
	get_grid().reset()
	_tiles_open.clear()
	_tiles_closed.clear()
	_tiles_search_open.clear()
	_tiles_search_closed.clear()
	_tile_current = null
	_tile_error = null
	_tile_search = null
	_debug_nuke_counter = 0
	# TODO: Reset the loop counter here

func get_run_time() -> float: 
	return _debug_time if !_is_processing else -1.0

func is_gen_success() -> bool:
	_c_success = 0
	while _c_success < get_grid().get_size():
		if get_grid().get_tile(_c_success).get_tile_type() == -1:
			break
		_c_success += 1
	
	return _c_success == get_grid().get_size()

func is_processing() -> bool:
	return _is_processing

func get_data() -> DS_WFC_Data:
	return _data

func get_tile_names() -> Array[String]:
	return _data.get_tile_names()

func _process_grid() -> void:
	while !_tiles_open.is_empty(): # Loop to process all the tiles using wave function collapse
		_c1 = 0 # Index of the open tiles
		_c2 = 0 # For storing the lowest entropy index
		_entropy = -1

		while _c1 < _tiles_open.size(): # Loop for finding the lowest entropy
			_temp_rules = _get_rules(_tiles_open[_c1])

			if _entropy == -1 || _temp_rules.size() < _entropy: # Condition for finding the lowest entropy
				_c2 = _c1 # Storing the index of the lowest entropy
				_entropy = _temp_rules.size() # Updating the entropy value
				_rules = _temp_rules.duplicate() # Storing the lowest entropy rules

			_c1 += 1
		
		_tile_current = _tiles_open.pop_at(_c2) # Getting the lowest entropy tile

		if _tile_current.get_tile_type() == -1: # Checking if tile NOT processed
			_process_tile(_tile_current, _rules.duplicate()) # Processing the current tile
			if _tile_current.get_tile_type() == -1: # Condition for storing failed tiles
				if _tile_error == null: # Chekcing if NO error tiles found
					_c1 = 0
					while _c1 < _tile_current.get_edge_size(): # Loop for finding an error tile
						if _is_tile_processed(_tile_current.get_edge(_c1)): # Condition for finding the first processed tile as error tile
							if !_tile_current.get_edge(_c1).is_fixed(): # Checking if the tile is NOT fixed
								_tile_error = _tile_current.get_edge(_c1) # Setting the error tile
								break
						_c1 += 1
				
				_reprocess_tile() # Reprocessing to fix error
		
		_c1 = 0

		# Loop for adding more tiles for processing
		while _c1 < _tile_current.get_edge_size():
			if _tile_current.get_edge(_c1) != null:
				# Checking if the tile has NOT been processed
				if (_tile_current.get_edge(_c1).get_tile_type() == -1
				&& !_tiles_open.has(_tile_current.get_edge(_c1))
				&& !_tiles_closed.has(_tile_current.get_edge(_c1))):
					_tiles_open.append(_tile_current.get_edge(_c1))
			_c1 += 1
		
		_tiles_closed.append(_tile_current) # The current tile has been processed

## This method reprocesses to fix the error.
func _reprocess_tile() -> void:
	# NOTE: After the loop _tile_current will become _tile_error as further call to _is_found_type method
	#		has the potential to replace the _tile_error value again.
	# while _tile_current != _tile_error && !_tiles_closed.is_empty(): # Loop for finding the error tile
	# 	_tile_current.reset_tile() # Resetting the tile for reprocessing
	# 	if !_tiles_open.has(_tile_current): _tiles_open.append(_tile_current) # Adding back the resetted tile back to the open tiles for re-processing
	# 	_tile_current = _tiles_closed.pop_back() # Popping from the closed tiles and thus making it available for processing
	
	# # Condition for NOT finding a match after rotational fix
	# if !_is_found_type(_tile_current, _tile_current.get_tile_type(), _tile_current.get_tile_rotation_value() + 1):
	# 	_rules = _get_rules(_tile_current) # Getting rules for the error tile after failed rotational fix
	# 	_rules.erase(_tile_current.get_tile_type()) # Removing the already applied tile type
	# 	_tile_current.reset_tile() # Resetting the tile for reprocessing
	# 	_process_tile(_tile_current, _rules.duplicate()) # Reprocessing to find a new tile type for the error tile

	# 	if _tile_current.get_tile_type() == -1: # Checking if a new tile type is NOT found
	# 		if _nuke_limit == -1 || _debug_nuke_counter < _nuke_limit: # Condition for nuking tiles 
	# 			_nuke(_tile_current, 0, 0, -1) # Nuking tiles to get better results
	# 			_debug_nuke_counter += 1 # For counting the number nukes being fired

	# Condition for failed rotational fix of the error tile
	if !_is_found_type(_tile_error, _tile_error.get_tile_type(), _tile_error.get_tile_rotation_value() + 1):
		_c_re1 = 0
		while _c_re1 < _tile_current.get_edge_size(): # Loop for going through all the edges to find a new type for the current tile
			if _is_tile_processed(_tile_current.get_edge(_c_re1)): # Checking if the edge tile has been processed
				_type_stored = _tile_current.get_edge(_c_re1).get_tile_type() # Storing edge's type
				_rot_stored = _tile_current.get_edge(_c_re1).get_tile_rotation_value() # Storing edge's rot value

				# Checking if new rotation found for the neighbouring tile
				if _is_found_type(_tile_current.get_edge(_c_re1), _type_stored, _rot_stored + 1):
					_process_tile(_tile_current, _get_rules(_tile_current)) # Processing the current tile
					if _tile_current.get_tile_type() != -1: break # Condition for find type for the current tile
						
				_rules = _get_rules(_tile_current.get_edge(_c_re1)) # Getting all the rules for the edge tile
				_rules.erase(_type_stored) # Removing the current type of the edge from the rules

				while !_rules.is_empty(): # Loop to check if new edge tile type will fix the issue
					_tile_current.get_edge(_c_re1).reset() # Resetting the edge tile
					_process_tile(_tile_current.get_edge(_c_re1), _rules.duplicate()) # Processing the edge tile

					if _tile_current.get_edge(_c_re1).get_tile_type() != -1: # Checking if the edge tile has a new type
						_process_tile(_tile_current, _get_rules(_tile_current)) # Processing the current tile
						if _tile_current.get_tile_type() != -1: break # Checking if current tile found a type and ending loop
						else: _rules.erase(_tile_current.get_edge(_c_re1).get_tile_type()) # Removing the edge's tile type from the rule list
					else: break # No type found for the edge tile breaking the loop

				if _tile_current.get_tile_type() != -1: break # Condition for found new tile type and stopping further searches
				else: # Condition for resetting the edge's value to stored values
					_tile_current.get_edge(_c_re1).set_tile_type(_type_stored)
					_tile_current.get_edge(_c_re1).set_tile_rotation_value(_rot_stored)
				
			_c_re1 += 1
		
		if _tile_current.get_tile_type() == -1: # Condition for nuking the current tile
			if _nuke_limit == -1 || _debug_nuke_counter < _nuke_limit:
				_DELETE_ME -= 1
				if _DELETE_ME == 0:
					print("Nuking Tile: ", get_tile_index(_tile_current))
					print("BEFORE:")
					print(self)
				_nuke(_tile_current, 0, 0, -1) # Condition for nuking tiles to get better results
				# _tiles_open.append(_find_nearest_none_processed_tile(_tile_current, 0, -1)) # Adding the correct tile to start the process
				_tiles_open.append(_find_nearest_none_processed_tile(_tile_current)) # Adding the correct tile to start the process
				_debug_nuke_counter += 1 # For counting the number nukes being fired
				if _DELETE_ME == 0:
					print("AFTER:")
					print(self)

## This method adds all the failed tiles back to be processed again.
func _add_failed_tiles() -> void:
	_c_failed = 0
	while _c_failed < get_grid().get_size(): # Loop for finding the failed tiles
		if get_grid().get_tile(_c_failed).get_tile_type() == -1: # Failed tile found
			_tiles_open.append(get_grid().get_tile(_c_failed))
			_tiles_closed.erase(get_grid().get_tile(_c_failed))
		_c_failed += 1

## This method gets the available rules for a tile but also using one edge of the tile
## as a temp value.
func _get_rules_temp_tile(tile:DS_Tile, edge:int, type:int) -> Array[int]:
	_temp = _data.get_all_rules()
	_c_rule1 = 0 # Edge index
	while _c_rule1 < tile.get_edge_size(): # Loop for going through all the edges
		if tile.get_edge(_c_rule1) != null:
			# Condition for getting the available rules
			if (tile.get_edge(_c_rule1).get_tile_type() != -1 || _c_rule1 == edge):
				_temp2.clear() # Clearing previous data

				# Getting all the rules from the edge's rotation and opposite edge
				_temp2 = _data.get_edge_rules(
					tile.get_edge(_c_rule1).get_tile_type() if _c_rule1 != edge else type,
					tile.get_edge(_c_rule1).get_rotational_edge_index(
						_get_edge_opposite_index(
							_c_rule1,
							tile.get_edge(_c_rule1).get_edge_size()
						)
					)
				)
				
				_c_rule2 = _temp.size() - 1
				while _c_rule2 >= 0: # Loop for removing none common rules
					if !_temp2.has(_temp[_c_rule2]): # Rule NOT found
						_temp.remove_at(_c_rule2) # Removing rule
					_c_rule2 -= 1
		_c_rule1 += 1
	
	return _temp.duplicate()

## This method gets all the available rules for a tile.
func _get_rules(tile:DS_Tile) -> Array[int]:
	return _get_rules_temp_tile(tile, -1, -1)

## This method process the tile.
func _process_tile(tile: DS_Tile, rules: Array[int]) -> void:
	while !rules.is_empty(): # Loop for processing the tile
		_tile_error = null # Resetting the error tile at the new tile selection
		_prob = _rng.randf() # Getting probability value
		_prob_total = (1.0 / rules.size()) # Resetting to find the tile type
		_c_process1 = 0 # Acts as rule index

		while _c_process1 < rules.size(): # Loop for randomly selecting a tile
			if _prob <= _prob_total: # Condition for selecting a tile
				break # Breaking loop, tile selected which is _c_process1
			else: # Setting next tile type to be checked
				_prob_total += (1.0 / rules.size())
			_c_process1 += 1
		
		if _is_found_type(tile, rules[_c_process1], 0): # Found a type to set
			tile.set_tile_type(rules[_c_process1])
			# print("--- Selected Type: ", tile.get_tile_type())
			break
		else: # Found no type, removing currently processed type for checking others
			rules.remove_at(_c_process1)

## This method rotates the tiles and checks if the tile matches after rotation.
func _is_found_type(tile:DS_Tile, type:int, rot:int) -> bool:
	if !tile.is_fixed(): # Checking if the tile is NOT fixed
		while rot < 4: # Loop for rotating the tile
			tile.set_tile_rotation_value(rot) # Setting the rotation of the tile
			_c_found1 = 0 # This counter acts as edge index

			while _c_found1 < tile.get_edge_size(): # Loop for finding a match
				if tile.get_edge(_c_found1) != null:
					if tile.get_edge(_c_found1).get_tile_type() != -1: # Checking if neighbour tile has been set
						
						# Storing the selected tile's rotated rules
						_temp_rules = _data.get_edge_rules(
							type,
							tile.get_rotational_edge_index(_c_found1)
						)

						# Condition for NOT finding any matches so breaking the loop for the next check
						if !_temp_rules.has(tile.get_edge(_c_found1).get_tile_type()):
							_tile_error = tile.get_edge(_c_found1) # Storing the tile that caused error
							break
						else: # Condtion to check if neighbour allows to set the tile
							# Storing the neighbour's edge rules toward the current tile
							_temp_rules = _data.get_edge_rules(
								tile.get_edge(_c_found1).get_tile_type(),
								tile.get_edge(_c_found1).get_rotational_edge_index(
									_get_edge_opposite_index(
										_c_found1,
										tile.get_edge(_c_found1).get_edge_size()
									)
								)
							)

							if !_temp_rules.has(type): # NO matches found from the neighbour's edge
								_tile_error = tile.get_edge(_c_found1) # Storing the tile that caused error
								break
					else: # Neighbour tile has NOT been set
						# Condition to check if current tile rotation does NOT allows neighbour tile to have
						# at least 1 tile rule, which is entropy > 0
						if (_get_rules_temp_tile(
								tile.get_edge(_c_found1),
								_get_edge_opposite_index(
									_c_found1, 
									tile.get_edge(_c_found1).get_edge_size()
								),
								type
							).size() == 0):
							break

				_c_found1 += 1
			
			if _c_found1 == tile.get_edge_size(): # Found a match
				return true
			rot += 1

	return false

# ## This method nukes the tiles.
# func _nuke(tile:DS_Tile, cur:int, counter:int, ignore_edge:int) -> void:
# 	if tile == null: return
# 	tile.reset_tile()
# 	_tiles_closed.erase(tile) # Re-opening tile for processing

# 	if !_tiles_open.has(tile): _tiles_open.append(tile) # Condition for re-adding the nuked tile for reprocess
	
# 	if cur >= _nuke_range: # Condition for stopping the recurssion for limit reached
# 		return

# 	while counter < tile.get_edge_size(): # Loop for nuking the edges
# 		if counter != ignore_edge: # Checking if edge is NOT ignore edge
# 			_nuke(tile.get_edge(counter), cur + 1, 0, _get_edge_opposite_index(_counter, tile.get_edge_size())) # Nuking edge
# 		counter += 1

## This method nukes the tiles.
func _nuke(tile:DS_Tile, cur:int, counter:int, ignore_edge:int) -> void:
	if tile == null: return
	if tile.is_fixed(): return # Fixed tile found, must stop encroching here
	tile.reset()
	_tiles_open.erase(tile) # Removing from open so that the fanning process can happen
	_tiles_closed.erase(tile) # Re-opening tile for processing

	# if !_tiles_open.has(tile): _tiles_open.append(tile) # Condition for re-adding the nuked tile for reprocess
	
	if cur >= _nuke_range: # Condition for stopping the recurssion for limit reached
		return

	while counter < tile.get_edge_size(): # Loop for nuking the edges
		if counter != ignore_edge: # Checking if edge is NOT ignore edge
			_nuke(tile.get_edge(counter), cur + 1, 0, _get_edge_opposite_index(_counter, tile.get_edge_size())) # Nuking edge
		counter += 1

## This method finds the nearest none processed tile to a processed tile from the given tile.
func _find_nearest_none_processed_tile(tile:DS_Tile) -> DS_Tile:
	_tiles_search_closed.clear() # Clearing previous data
	_tiles_search_open.clear() # Clearing previous data
	_tiles_search_open.append(tile)

	while !_tiles_search_open.is_empty(): # Loop to find the closest none processed tile
		_tile_search = _tiles_search_open.pop_back()
		
		_c_search = 0
		while _c_search < _tile_search.get_edge_size(): # Loop to go through all the edges
			if _is_tile_processed(_tile_search.get_edge(_c_search)): return _tile_search # Tile found

			# Condition to add the tile for searching
			if (!_tiles_search_open.has(_tile_search.get_edge(_c_search)) &&
				!_tiles_search_closed.has(_tile_search.get_edge(_c_search))):
				_tiles_search_open.append(_tile_search.get_edge(_c_search))
			_c_search += 1
		
		_tiles_search_closed.append(_tile_search) # Adding tile to closed search list
	
	return null


# ## This method finds the nearest none processed tile to a processed tile from the given tile.
# func _find_nearest_none_processed_tile(tile:DS_Tile, counter:int, sent_edge:int) -> DS_Tile:
# 	_tile_search = null
# 	if _is_tile_processed(tile): return tile.get_edge(sent_edge)
# 	if tile == null: return null

# 	while counter < tile.get_edge_size(): # Loop to go through all the tile edges
# 		# Storing the search tile
# 		_tile_search = _find_nearest_none_processed_tile(tile.get_edge(counter), 0, 
# 			_get_edge_opposite_index(counter, tile.get_edge_size()))
# 		if _tile_search != null: break # Tile found stopping any further searches
# 		counter += 1
	
# 	return _tile_search

## This method checks if the tile has been processed.
func _is_tile_processed(tile:DS_Tile) -> bool:
	if tile == null: return false # Null tiles are always false
	return tile.get_tile_type() != -1

## This method gets the opposite index of the given edge index.
func _get_edge_opposite_index(index:int, size:int) -> int:
	return index + 3 if (index + 3) < size else index - 3

## This method gets the total successful tiles.
func _total_successful_tiles() -> void:
	_c_success = 0
	_c_success2 = 0
	while _c_success2 < get_grid().get_size(): # Loop for finding all the successful tiles
		if get_grid().get_tile(_c_success2).get_tile_type() != -1:
			_c_success += 1
		_c_success2 += 1

func _DELETE_ME_METHOD() -> String:
	var msg = "["
	var c = 0
	while c < _tiles_open.size():
		msg += str(get_tile_index(_tiles_open[c])) + ", "
		c += 1
	msg += "]"
	return msg

func _to_string() -> String:
	print_rich(get_grid().show_grid_index_index(_index_start_tile))
	print("") # Next line
	print_rich(get_grid().show_grid_tile_index(_index_start_tile))
	print("") # Next line
	print_rich(get_grid().show_grid_tile_rot_index(_index_start_tile))
	return ""
