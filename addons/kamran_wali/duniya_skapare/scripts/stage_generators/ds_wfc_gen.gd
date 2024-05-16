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
var _start_tile_type: int
# @export var _retrace_limit:= 3 # TODO: Make sure it is NOT below 1
@export var _is_debug: bool
@export_group("Nuke Properties")
@export var _nuke_range:= 3 # TODO: Make sure it is NOT below 1
@export var _nuke_limit:= -1 # TODO: Make sure it is NOT below -1

# Properties for internal usage ONLY
var _tiles_open: Array[DS_Tile]
var _tiles_closed: Array[DS_Tile]
var _tile_current: DS_Tile
var _tile_error: DS_Tile
var _rules: Array[int] # Final rules
var _rng = RandomNumberGenerator.new()
var _prob:= -1.0
var _prob_total:= -1.0
var _temp_rules: Array[int]
var _temp: Array[int]
var _temp2: Array[int]
var _entropy:= -1
var _type_names: String
var _grid_pos_names: String
var _c1:= -1
var _c2:= -1
var _c_rule1:= -1
var _c_rule2:= -1
var _c_process1:= -1
var _c_found1:= -1
var _c_success:= -1
var _debug_time:= 1.0
var _debug_nuke_counter:= 0
var _is_processing:= false

func _get_configuration_warnings():
	var warnings: Array[String]
	
	if _data == null:
		warnings.append("Data: Please give a wave function collapse Data. it can NOT be null.")
	
	return warnings

func _get_property_list():
	var properties = []

	if _data != null: # Checking if data is NOT null
		_type_names = ""
		_c1 = 0

		# Loop for loading up all the tile type names
		while _c1 < _data.get_number_of_tiles():
			_type_names += (_data.get_tile_name(_c1) + 
				("," if _c1 < _data.get_number_of_tiles() - 1 
				else ""))
			_c1 += 1

		properties.append({
			"name" : "_start_tile_type",
			"type" : TYPE_INT,
			"hint" : PROPERTY_HINT_ENUM,
			"hint_string" : _type_names
		})

		set_grid()

		if get_grid() != null:
			_grid_pos_names = ""
			_c1 = 0

			while _c1 < get_grid().get_size():
				_grid_pos_names += (str(_c1) + ("," if _c1 < _grid.get_size() - 1 else ""))
				_c1 += 1
			
			# Showing the names as enums
			properties.append({
				"name" : "_index_start_tile",
				"type" : TYPE_INT,
				"hint" : PROPERTY_HINT_ENUM,
				"hint_string" : _grid_pos_names
			})
	
	return properties

func setup() -> void:
	if _is_debug: _debug_time = Time.get_unix_time_from_system() # Condition for starting debug time
	_is_processing = true # Setting processing flag to true
	get_grid().get_tile(_index_start_tile).set_tile_type(_start_tile_type)
	_tiles_open.clear() # Clearing data from previous setup
	_tiles_open.append(get_grid().get_tile(_index_start_tile))

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
				# print_rich("[color=green]Tile:, ", get_tile_index(_tile_current),"[/color]")
				# print("- Rules: ", _rules)
				# print_rich("[color=red]- Tile Failed. Starting retrace process[/color]")

				if _tile_error == null: # Chekcing if NO error tiles found
					# TODO: If current way of finding error does NOT work then try using lowest entropy method
					# print_rich("[color=orange]No error tile found. Setting the first processed tile as error tile[/color]")
					_c1 = 0
					while _c1 < _tile_current.get_edge_size(): # Loop for finding an error tile
						if _is_tile_processed(_tile_current.get_edge(_c1)): # Condition for finding the first processed tile as error tile
							_tile_error = _tile_current.get_edge(_c1) # Setting the error tile
							break
						_c1 += 1
				
				_reprocess() # Reprocessing to fix error
				# print_rich("[color=green]===XXX===[/color]")
		
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
	
	# print_rich("[color=green]===XXX===[/color]")
	# Condition for showing the debug info
	if _is_debug: 
		print("Total Process Time: ", ((Time.get_unix_time_from_system() - _debug_time) * 1000), "ms")
		if _debug_nuke_counter != 0: print_rich("[color=orange]Total nukes fired: ", _debug_nuke_counter, "[/color]")
		if is_gen_success(): print_rich("[color=green]Wave Function Collapse: Successful![/color]")
		else: 
			print_rich("[color=red]Wave Function Collapse: Failed![/color]")
			print(self)
	_is_processing = false # Setting processing flag to false

func reset() -> void:
	get_grid().reset()
	_tiles_open.clear()
	_tiles_closed.clear()
	_tile_current = null
	_tile_error = null
	_debug_nuke_counter = 0

func is_gen_success() -> bool:
	_c_success = 0
	while _c_success < get_grid().get_size():
		if get_grid().get_tile(_c_success).get_tile_type() == -1:
			break
		_c_success += 1
	
	return _c_success == get_grid().get_size()

func is_processing() -> bool:
	return _is_processing

## This method reprocesses to fix the error.
func _reprocess() -> void:
	# print("-- Tile Error Is Null: ", (_tile_error == null))
	# print("-- Tile Error Index: ", get_tile_index(_tile_error))

	# NOTE: After the loop _tile_current will become _tile_error as further call to _is_found_type method
	#		has the potential to replace the _tile_error value again.
	while _tile_current != _tile_error && !_tiles_closed.is_empty(): # Loop for finding the error tile
		_tile_current.reset_tile() # Resetting the tile for reprocessing
		if !_tiles_open.has(_tile_current): _tiles_open.append(_tile_current) # Adding back the resetted tile back to the open tiles for re-processing
		_tile_current = _tiles_closed.pop_back() # Popping from the closed tiles and thus making it available for processing
		# print("-- Searching Error Tile: ", get_tile_index(_tile_current), ", current type: ", _tile_current.get_tile_type())
	
	# Condition for NOT finding a match after rotational fix
	if !_is_found_type(_tile_current, _tile_current.get_tile_type(), _tile_current.get_tile_rotation_value() + 1):
		_rules = _get_rules(_tile_current) # Getting rules for the error tile after failed rotational fix
		_rules.erase(_tile_current.get_tile_type()) # Removing the already applied tile type

		_tile_current.reset_tile() # Resetting the tile for reprocessing
		_process_tile(_tile_current, _rules.duplicate()) # Reprocessing to find a new tile type for the error tile

		if _tile_current.get_tile_type() == -1: # Checking if a new tile type is NOT found
			# print_rich("[color=purple]-- Nuking process started for tile: ", get_tile_index(_tile_current), "[/color]")
			if _nuke_limit == -1 || _debug_nuke_counter < _nuke_limit: 
				_nuke(_tile_current, 0, 0, -1) # Condition for nuking tiles to get better results
				_debug_nuke_counter += 1 # For counting the number nukes being fired
	# 	else:
	# 		print_rich("[color=yellow]-- Tile Fixed. Reprocess. Type: ", _tile_current.get_tile_type(),"[/color]")
	# else:
	# 	print_rich("[color=yellow]-- Tile Fixed. Rotation. Type: ", _tile_current.get_tile_type(),"[/color]")

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
	while rules.size() != 0:
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

func _is_found_type(tile:DS_Tile, type:int, rot:int) -> bool:
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

## This method nukes the tiles.
func _nuke(tile:DS_Tile, cur:int, counter:int, ignore_edge:int) -> void:
	if tile == null: return
	tile.reset_tile()
	_tiles_closed.erase(tile) # Re-opening tile for processing
	if !_tiles_open.has(tile): _tiles_open.append(tile) # Condition for re-adding the nuked tile for reprocess
	
	if cur >= _nuke_range: # Condition for stopping the recurssion for limit reached
		return

	while counter < tile.get_edge_size(): # Loop for nuking the edges
		if counter != ignore_edge: # Checking if edge is NOT ignore edge
			_nuke(tile.get_edge(counter), cur + 1, 0, _get_edge_opposite_index(_counter, tile.get_edge_size())) # Nuking edge
		counter += 1

## This method checks if the tile has been processed.
func _is_tile_processed(tile:DS_Tile) -> bool:
	if tile == null: return false # Null tiles are always false
	return tile.get_tile_type() != -1

## This method gets the opposite index of the given edge index.
func _get_edge_opposite_index(index:int, size:int) -> int:
	return index + 3 if (index + 3) < size else index - 3

func _to_string() -> String:
	print_rich(get_grid().show_grid_index_index(_index_start_tile))
	print("") # Next line
	print_rich(get_grid().show_grid_tile_index(_index_start_tile))
	print("") # Next line
	print_rich(get_grid().show_grid_tile_rot_index(_index_start_tile))
	return ""
