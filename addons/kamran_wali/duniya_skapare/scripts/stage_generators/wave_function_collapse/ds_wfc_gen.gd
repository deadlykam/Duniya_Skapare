@tool
extends DS_BaseGen

@export_category("Wave Function Collapse")
@export var _data: DS_WFC_Data:
	set(p_data):
		if _data != p_data:
			_data = p_data
			update_configuration_warnings()

@export var _is_lock_tiles:= true

@export_group("Nuke Properties")
@export var _nuke_range:= 3:
	set(nuke_range):
		if _nuke_range != nuke_range:
			_nuke_range = nuke_range if nuke_range >= 1 else 1

@export_group("Fail Safe Properties")
@export var _nuke_limit:= -1:
	set(nuke_limit):
		if _nuke_limit != nuke_limit:
			_nuke_limit = nuke_limit if nuke_limit >= -1 else -1

@export var _loop_limit:= -1:
	set(loop_limit):
		if _loop_limit != loop_limit:
			_loop_limit = loop_limit if loop_limit >= -1 else -1

@export_group("Debug Properties")
@export var _is_debug: bool
@export var _is_debug_tile_index:= false
@export var _is_debug_tile_type:= false
@export var _is_debug_tile_rot:= false
@export var _is_debug_tile_coord:= false
@export var _is_debug_self_print:= false

# Properties for internal usage ONLY
var _index_start_tile: int
var _tiles_open: Array[DS_Tile]
var _tiles_closed: Array[DS_Tile]
var _tiles_search_open: Array[DS_Tile]
var _tiles_search_closed: Array[DS_Tile]
var _tile_current: DS_Tile
var _tile_error: DS_Tile
var _tile_reprocess: DS_Tile
var _tile_search: DS_Tile
var _tile_add: DS_Tile
var _temp_ic: DS_InvalidComboData
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
var _c_lock:= 0
var _c_re1:= -1
var _c_rule1:= -1
var _c_rule2:= -1
var _c_process1:= -1
var _c_found1:= -1
var _c_success:= -1
var _c_success2:= -1
var _c_failed:= -1
var _c_search:= -1
var _c_convert:= -1
var _c_loop:= 0
var _c_ic:= -1
var _c_loaded:= 0
var _c_loaded2:= 0
var _percentage_loaded:= 0
var _type_stored:= -1
var _rot_stored:= -1
var _debug_time:= 1.0
var _debug_total_time:= 0.0
var _debug_nuke_counter:= 0
var _is_processing:= false

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	warnings = super._get_configuration_warnings()
	
	if _data == null:
		warnings.append("Data: Please give a wave function collapse Data. it can NOT be null.")
	
	return warnings

## This method adds the tile to be processed.
func add_tile_to_process(tile:DS_Tile) -> void: _tiles_open.append(tile)

## This method gets the opposite index of the given edge index.
func get_edge_opposite_index(index:int, size:int) -> int:
	return index + 3 if (index + 3) < size else index - 3

func setup() -> void:
	start_debug_timer() # Starting the debug timer

	if get_start_tiles().size() != 0: # Condition for setting the start tiles
		_c1 = 0
		
		while _c1 < get_start_tiles().size(): # Loop for setting the starting tiles
			get_grid().get_tile(get_start_tiles()[_c1].get_index()).set_tile_type(get_start_tiles()[_c1].get_type()) # Setting type
			get_grid().get_tile(get_start_tiles()[_c1].get_index()).set_tile_rotation_value(get_start_tiles()[_c1].get_rot_value()) # Setting rot value
			get_grid().get_tile(get_start_tiles()[_c1].get_index()).set_is_fixed(get_start_tiles()[_c1].is_fixed()) # Setting fixed tile
			_tiles_open.append(get_grid().get_tile(get_start_tiles()[_c1].get_index())) # Adding the tile to be processed
			_c1 += 1
	else:
		_index_start_tile = _rng.randi_range(0, get_grid().get_tiles_size() - 1) # Getting a random tile for start tile
		_tiles_open.append(get_grid().get_tile(_index_start_tile)) # Adding the first tile to be processed

	if _temp_ic == null: _temp_ic = DS_InvalidComboData.new() # Initiating the invalid combo data
	process_main(true) # Starting the main process

## This is the main process which does all the processes.
func process_main(is_search:bool) -> void:
	_is_processing = true # Setting processing flag to true
	
	while true: # Loop for running the process using wave function collapse, Main Process Loop
		_process_grid(is_search) # Using wave function collapse to process the grid
		if is_gen_success() || (_debug_nuke_counter >= _nuke_limit && _nuke_limit != -1): break # Condition for breaking processing loop
		else: # Condition for adding back all the failed tiles
			_add_failed_tiles() # Getting all the failed tiles to process again
			if _tiles_open.is_empty(): break # Stopping process as NO more tiles found for processing
		_c_loop += 1 # Incrementing the fail safe loop counter
		if _c_loop == _loop_limit: break # Fail safe loop break
	
	if _is_lock_tiles: # Condition to check if to lock the tile
		# _c_lock = 0
		while _c_lock < get_grid().get_tiles_size(): # Loop for locking the tiles
			get_grid().get_tile(_c_lock).set_is_fixed_actual(true) # Tile locked
			_c_lock += 1
	
	if _is_debug: # Condition for showing the debug info
		print_rich("[color=purple]===WFC Result===[/color]")
		print_debug_info()
		print_rich("[color=purple]===XXX===[/color]")

	_is_processing = false # Setting processing flag to false

## This method starts the debug timer.
func start_debug_timer() -> void:
	if _is_debug: _debug_time = Time.get_unix_time_from_system() # Condition for starting debug time

## This method gets the debug timer.
func get_debug_timer() -> float: return ((Time.get_unix_time_from_system() - _debug_time) * 1000)

## This method sets the processing.
func set_processing(is_enabled:bool) -> void: _is_processing = is_enabled

# This method resets the fail safe values.
func reset_fail_safe() -> void:
	_debug_nuke_counter = 0
	_c_loop = 0

## This method ONLY resets the generator.
func reset_gen() -> void:
	_tiles_open.clear()
	_tiles_closed.clear()
	_tiles_search_open.clear()
	_tiles_search_closed.clear()
	_tile_current = null
	_tile_error = null
	_tile_reprocess = null
	_tile_search = null
	_percentage_loaded = 0
	reset_fail_safe()

## This method resets the grid and the generator.
func reset() -> void:
	get_grid().reset()
	reset_gen()
	_c_lock = 0

func get_start_index() -> int:
	return _index_start_tile if get_start_tiles().size() == 0 else get_start_tiles()[0]

func get_run_time() -> float: 
	return _debug_total_time if !_is_processing else -1.0

func is_gen_success() -> bool:
	_c_success = 0
	while _c_success < get_grid().get_tiles_size(): # Loop to check if generation was successful
		if (get_grid().get_tile(_c_success).get_tile_type() == -1): break # Condition for finding a failed tile
		_c_success += 1
	return _c_success == get_grid().get_tiles_size()

func get_process_loop() -> int: return _c_loop
func is_gen_process() -> bool: return _is_processing
func get_data(): return _data
func get_tile_names(): return _data.get_tile_names()

func get_percentage_loaded_normal() -> float:
	_c_loaded = 0
	_c_loaded2 = 0
	while _c_loaded < get_grid().get_tiles_size():
		if get_grid().get_tile(_c_loaded).get_tile_type() != -1: _c_loaded2 += 1
		_c_loaded += 1
	
	_percentage_loaded = _c_loaded2 if _percentage_loaded < _c_loaded2 else _percentage_loaded
	return float(_percentage_loaded) / get_grid().get_tiles_size() if _is_processing else 1.0

func print_debug_info() -> void:
	_debug_total_time = get_debug_timer()
	print("Grid Size: ", get_grid().get_grid_size_x(), " X ", get_grid().get_grid_size_y(), " X ", get_grid().get_grid_size_z())
	print("Run Time: ", _debug_total_time, "ms")
	
	if is_gen_success(): print_rich("[color=green]Wave Function Collapse: Successful![/color]")
	else: print_rich("[color=red]Wave Function Collapse: Failed![/color]")

	_total_successful_tiles() # Finding all the successful tiles
	print_rich("[color=#40ff70]Tiles Succeeded: ", _c_success,"[/color], [color=red]Tiles Failed: ", 
		(get_grid().get_tiles_size() - _c_success), "[/color], Success Rate: ", ((float(_c_success) / float(get_grid().get_tiles_size())) * 100.0), "%")
	
	if _debug_nuke_counter == _nuke_limit: print_rich("[color=red]Fail Safe Activated: Maximum nuke fired![/color]")
	else: print_rich("[color=orange]Number Of Nukes Fired: ", _debug_nuke_counter, "[/color]")
	
	if _c_loop == _loop_limit: print_rich("[color=red]Fail Safe Activated: Maximum loop reached![/color]")
	else: print_rich("[color=orange]Number Of Process Loops: ", _c_loop, "[/color]")

	if _is_debug_self_print: _to_string() # Printing self

## This method processes the grid.
func _process_grid(is_search:bool) -> void:
	while !_tiles_open.is_empty(): # Loop to process all the tiles using wave function collapse
		_c1 = 0 # Index of the open tiles
		_c2 = 0 # For storing the lowest entropy index
		_entropy = -1
		_tile_error = null # Resetting the error in case 0 entropy found
		_tile_reprocess = null # Resetting the reprocess tile for further usage
		
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
				_tile_reprocess = _tile_error # Storing the error tile to reprocess
				if _tile_reprocess == null: # Chekcing if NO reprocess tiles found
					_c1 = 0
					while _c1 < _tile_current.get_edge_size(): # Loop for finding a tile to reprocess
						if _is_tile_processed(_tile_current.get_edge(_c1)): # Condition for finding the first processed tile to reprocess
							if !_tile_current.get_edge(_c1).is_fixed_actual(): # Checking if the tile is NOT fixed
								_tile_reprocess = _tile_current.get_edge(_c1) # Setting the tile to be reprocessed
								break
						_c1 += 1
				
				_reprocess_tile() # Reprocessing to fix error
		
		if is_search: # Condition to check if to search for more tiles for processing
			_c1 = 0
			while _c1 < _tile_current.get_edge_size(): # Loop for adding more tiles for processing
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
	if _tile_reprocess != null: # Condition for storing the reprocessed tile's type and rot value
		_type_stored = _tile_reprocess.get_tile_type() # Storing the reprocessed tile's type
		_rot_stored = _tile_reprocess.get_tile_rotation_value() # Storing the reprocessed tile's rotation
	
	# Condition for failed rotational fix of the reprocessed tile and also checking if _tile_reprocess is NOT null
	if (!_is_found_type(_tile_reprocess, _tile_reprocess.get_tile_type(), _tile_reprocess.get_tile_rotation_value() + 1) if _tile_reprocess != null else true):
		if _tile_reprocess != null: # Condition to reset the reprocessed tile's type and rotation values
			_tile_reprocess.set_tile_type(_type_stored) # Resetting the reprocessed tile's type
			_tile_reprocess.set_tile_rotation_value(_rot_stored) # Resetting the reprocessed tile's rotation
		
		_c_re1 = 0
		while _c_re1 < _tile_current.get_edge_size(): # Loop for going through all the edges to find a new type for the current tile
			if _is_tile_processed(_tile_current.get_edge(_c_re1)): # Checking if the edge tile has been processed
				if !_tile_current.get_edge(_c_re1).is_fixed_actual(): # Checking if the tile is NOT fixed
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
	else: _process_tile(_tile_current, _get_rules(_tile_current)) # Processing current tile after successful reprocess tile rotation match

	if _tile_current.get_tile_type() == -1: # Condition for nuking the current tile
		if _nuke_limit == -1 || _debug_nuke_counter < _nuke_limit:
			_nuke(_tile_current, 0, 0, -1) # Condition for nuking tiles to get better results
			_tiles_open.append(_find_nearest_none_processed_tile(_tile_current)) # Adding the correct tile to start the process
			_debug_nuke_counter += 1 # For counting the number nukes being fired

## This method adds all the failed tiles back to be processed again.
func _add_failed_tiles() -> void:
	_c_failed = 0
	while _c_failed < get_grid().get_tiles_size(): # Loop for finding the failed tiles
		# Condition for finding a failed tile
		if (get_grid().get_tile(_c_failed).get_tile_type() == -1 and
			!get_grid().get_tile(_c_failed).is_fixed_actual()):
			_tiles_open.append(get_grid().get_tile(_c_failed))
			_tiles_closed.erase(get_grid().get_tile(_c_failed))
		_c_failed += 1

## This method gets the available rules for a tile but also using one edge of the tile
## as a temp value.
func _get_rules_temp_tile(tile:DS_Tile, edge:int, type:int) -> Array[int]:
	_temp = _data.get_all_rules() # Storing all the rules for deduction
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
						get_edge_opposite_index(
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
			break
		else: # Found no type, removing currently processed type for checking others
			rules.remove_at(_c_process1)

## This method rotates the tiles and checks if the tile matches after rotation.
func _is_found_type(tile:DS_Tile, type:int, rot:int) -> bool:
	if !tile.is_fixed_actual(): # Checking if the tile is NOT fixed
		while rot < 4: # Loop for rotating the tile
			tile.set_tile_rotation_value(rot) # Setting the rotation of the tile
			_c_found1 = 0 # This counter acts as edge index

			while _c_found1 < tile.get_edge_size(): # Loop for finding a match by checking all the edges
				if tile.get_edge(_c_found1) != null:
					if tile.get_edge(_c_found1).get_tile_type() != -1: # Checking if neighbour tile has been set
						
						# Storing the selected tile's rotated rules
						_temp_rules = _data.get_edge_rules(
							type,
							tile.get_rotational_edge_index(_c_found1)
						)

						# Condition for NOT finding any matches with edge so breaking the loop for the next check
						if !_temp_rules.has(tile.get_edge(_c_found1).get_tile_type()):
							_tile_error = tile.get_edge(_c_found1) if !tile.get_edge(_c_found1).is_fixed_actual() else _tile_error # Storing the tile that caused error
							break
						else: # Condtion to check if neighbour allows to set the tile
							# Storing the neighbour's edge rules toward the current tile
							_temp_rules = _data.get_edge_rules(
								tile.get_edge(_c_found1).get_tile_type(),
								tile.get_edge(_c_found1).get_rotational_edge_index(
									get_edge_opposite_index(
										_c_found1,
										tile.get_edge(_c_found1).get_edge_size()
									)
								)
							)

							if !_temp_rules.has(type): # NO matches found from the neighbour's edge
								_tile_error = tile.get_edge(_c_found1) if !tile.get_edge(_c_found1).is_fixed_actual() else _tile_error # Storing the tile that caused error
								break
							
							# Checking if invalid combination found, breaking loop for next check
							if !_is_valid_combination(tile.get_tile_rotation_value(), 
														type,
														tile.get_edge(_c_found1).get_tile_type(), 
														tile.get_edge(_c_found1).get_tile_rotation_value(), 
														_c_found1):
								_tile_error = tile.get_edge(_c_found1) if !tile.get_edge(_c_found1).is_fixed_actual() else _tile_error # Storing the tile that caused error
								break

							# Checking the valid combination in the edge tile against the current tile							
							if !_is_valid_combination(tile.get_edge(_c_found1).get_tile_rotation_value(),
														tile.get_edge(_c_found1).get_tile_type(),
														type,
														tile.get_tile_rotation_value(),
														get_edge_opposite_index(_c_found1, tile.get_edge_size())):
								_tile_error = tile.get_edge(_c_found1) if !tile.get_edge(_c_found1).is_fixed_actual() else _tile_error # Storing the tile that caused error
								break

					else: # Neighbour tile has NOT been set
						# Condition to check if current tile rotation does NOT allows neighbour tile to have
						# at least 1 tile rule, which is entropy > 0
						if (_get_rules_temp_tile(
								tile.get_edge(_c_found1),
								get_edge_opposite_index(
									_c_found1, 
									tile.get_edge(_c_found1).get_edge_size()
								),
								type
							).size() == 0):
							break

				_c_found1 += 1
			
			# Found a match by checking all the edges
			if _c_found1 == tile.get_edge_size(): return true
			rot += 1

	return false

## This method checks if the given tile combinations are valid.
func _is_valid_combination(tile_rot:int, tile_type:int, edge_tile_type:int, edge_tile_rot:int, edge_index:int) -> bool:
	#region NOTE:
	#			The reason for NOT making the _temp_ic null is because
	#			then it will be needed to be initiated again which may
	#			cause performance issue by generating garbage each time
	#			this method is called. So the 2nd best action to take is
	#			to just reset the values in _temp_ic and setting them again
	#endregion
	_temp_ic.reset_data() # Resetting the temp ic data
	_temp_ic.set_ic_data( # Setting the new temp ic data
		tile_rot,
		edge_index,
		edge_tile_type,
		edge_tile_rot
	)

	return !get_data().has_invalid_combo_element(tile_type, _temp_ic)

## This method nukes the tiles.
func _nuke(tile:DS_Tile, cur:int, counter:int, ignore_edge:int) -> void:
	if tile == null: return
	if tile.is_fixed_actual(): return # Fixed tile found, must stop encroching here
	tile.reset()
	_tiles_open.erase(tile) # Removing from open so that the fanning process can happen
	_tiles_closed.erase(tile) # Re-opening tile for processing
	
	if cur >= _nuke_range: # Condition for stopping the recurssion for limit reached
		return

	while counter < tile.get_edge_size(): # Loop for nuking the edges
		if counter != ignore_edge: # Checking if edge is NOT ignore edge
			_nuke(tile.get_edge(counter), cur + 1, 0, get_edge_opposite_index(_counter, tile.get_edge_size())) # Nuking edge
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

## This method checks if the tile has been processed.
func _is_tile_processed(tile:DS_Tile) -> bool:
	if tile == null: return false # Null tiles are always false
	return tile.get_tile_type() != -1

## This method gets the total successful tiles.
func _total_successful_tiles() -> void:
	_c_success = 0
	_c_success2 = 0
	while _c_success2 < get_grid().get_tiles_size(): # Loop for finding all the successful tiles
		if get_grid().get_tile(_c_success2).get_tile_type() != -1:
			_c_success += 1
		_c_success2 += 1

## This method converts the start array, Array[DS_TileInfo], to Array[int]
func _convert_start_array() -> Array[int]:
	_temp.clear() # Clearing previous data
	_c_convert = 0

	while _c_convert < get_start_tiles().size(): # Loop adding all the start index
		_temp.append(get_start_tiles()[_c_convert].get_index()) # Adding start index
		_c_convert += 1
	
	return _temp.duplicate()

func _to_string() -> String:
	if _is_debug_tile_index: # Debug for showing tile index
		print_rich(get_grid().show_grid_index_array(_convert_start_array())) if get_start_tiles().size() != 0 else print_rich(get_grid().show_grid_index_index(_index_start_tile))
		print("") # Next line
	
	if _is_debug_tile_type: # Debug for showing tile type
		print_rich(get_grid().show_grid_tile_array(_convert_start_array())) if get_start_tiles().size() != 0 else print_rich(get_grid().show_grid_tile_index(_index_start_tile))
		print("") # Next line
	
	if _is_debug_tile_rot: # Debug for showing tile rot
		print_rich(get_grid().show_grid_tile_rot_array(_convert_start_array())) if get_start_tiles().size() != 0 else print_rich(get_grid().show_grid_tile_rot_index(_index_start_tile))
		print("") # Next line
	
	if _is_debug_tile_coord: # Debug for showing tile coordinates
		print_rich(get_grid().show_grid_coord_array(_convert_start_array())) if get_start_tiles().size() != 0 else print_rich(get_grid().show_grid_coord_index(_index_start_tile))
	return ""
