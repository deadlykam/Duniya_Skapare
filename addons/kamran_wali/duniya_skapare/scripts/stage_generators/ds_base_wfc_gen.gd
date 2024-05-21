@tool
extends DS_BaseGen

# @export_category("Base Wave Function Collapse")
# @export var _data: DS_WFC_Data:
# 	set(p_data):
# 		if _data != p_data:
# 			_data = p_data
# 			update_configuration_warnings()

# @export_group("Nuke Properties")
# @export var _nuke_range:= 3:
# 	set(nuke_range):
# 		if _nuke_range != nuke_range:
# 			_nuke_range = nuke_range if nuke_range >= 1 else 1

# @export_group("Fail Safe Properties")
# @export var _nuke_limit:= -1:
# 	set(nuke_limit):
# 		if _nuke_limit != nuke_limit:
# 			_nuke_limit = nuke_limit if nuke_limit >= -1 else -1

# @export var _loop_limit:= -1:
# 	set(loop_limit):
# 		if _loop_limit != loop_limit:
# 			_loop_limit = loop_limit if loop_limit >= -1 else -1

# @export_group("Debug Properties")
# @export var _is_debug: bool

# # Properties for internal usage ONLY
# var _index_start_tile: int
# var _tiles_open: Array[DS_Tile]
# var _tiles_closed: Array[DS_Tile]
# var _tiles_search_open: Array[DS_Tile]
# var _tiles_search_closed: Array[DS_Tile]
# var _tile_current: DS_Tile
# var _tile_error: DS_Tile
# var _tile_search: DS_Tile
# var _rules: Array[int] # Final rules
# var _rng = RandomNumberGenerator.new()
# var _prob:= -1.0
# var _prob_total:= -1.0
# var _temp_rules: Array[int]
# var _temp: Array[int]
# var _temp2: Array[int]
# var _entropy:= -1
# var _c1:= -1
# var _c2:= -1
# var _c_re1:= -1
# var _c_rule1:= -1
# var _c_rule2:= -1
# var _c_process1:= -1
# var _c_found1:= -1
# var _c_success:= -1
# var _c_success2:= -1
# var _c_failed:= -1
# var _c_search:= -1
# var _c_convert:= -1
# var _type_stored:= -1
# var _rot_stored:= -1
# var _debug_time:= 1.0
# var _debug_nuke_counter:= 0
# var _c_loop:= 0
# var _is_processing:= false

# func _get_configuration_warnings() -> PackedStringArray:
# 	var warnings: PackedStringArray
# 	warnings = super._get_configuration_warnings()
	
# 	if _data == null:
# 		warnings.append("Data: Please give a wave function collapse Data. it can NOT be null.")
	
# 	return warnings

# func setup() -> void:
# 	_is_processing = true # Setting processing flag to true
# 	if _is_debug: _debug_time = Time.get_unix_time_from_system() # Condition for starting debug time

# 	if get_start_tiles().size() != 0: # Condition for setting the start tiles
# 		_c1 = 0
		
# 		while _c1 < get_start_tiles().size(): # Loop for setting the starting tiles
# 			get_grid().get_tile(get_start_tiles()[_c1].get_index()).set_tile_type(get_start_tiles()[_c1].get_type()) # Setting type
# 			get_grid().get_tile(get_start_tiles()[_c1].get_index()).set_tile_rotation_value(get_start_tiles()[_c1].get_rot_value()) # Setting rot value
# 			get_grid().get_tile(get_start_tiles()[_c1].get_index()).set_is_fixed(get_start_tiles()[_c1].is_fixed()) # Setting fixed tile
# 			_tiles_open.append(get_grid().get_tile(get_start_tiles()[_c1].get_index())) # Adding the tile to be processed
# 			_c1 += 1
# 	else:
# 		_index_start_tile = _rng.randi_range(0, get_grid().get_size() - 1) # Getting a random tile for start tile
# 		_tiles_open.append(get_grid().get_tile(_index_start_tile)) # Adding the first tile to be processed

# ## This method sets the processing status.
# func set_is_processing(is_process:bool) -> void:
# 	print("Here3")
# 	_is_processing = is_process

# func is_processing() -> bool:
# 	return _is_processing