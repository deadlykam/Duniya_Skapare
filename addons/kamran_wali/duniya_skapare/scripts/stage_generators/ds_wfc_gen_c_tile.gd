@tool
extends "res://addons/kamran_wali/duniya_skapare/scripts/stage_generators/ds_wfc_base_continuous.gd"

@export_category("Continuous Properties")
## Making this flag to true will make the tile addition to ignore height.
## If no height related rules found then the generator will crash.
@export var _ignore_height:= false

# Properties for internal usage ONLY
var _temp_grid: Array[DS_Tile]
var _free_edges: Array[int]
var _tile_new1: DS_Tile
var _tile_new2: DS_Tile
var _tile_temp: DS_Tile
var _temp_tiles: Array[int]
var _c_free:= -1
var _c_add1:= -1
var _c_add2:= -1

func get_tile_free_edges(tile:DS_Tile) -> Array[int]:
	if tile != null: # Checking if the tile exists
		_temp_tiles.clear() # Clearing previous data
		_c_free = 0
		while _c_free < tile.get_edge_size(): # Loop for getting all the free edges
			if tile.get_edge(_c_free) == null: # Checking if free edge found
				if is_tile_height_z(get_edge_z(tile, _c_free)): # Checking if null's height is valid
					_temp_tiles.append(_c_free) # Adding the free edge's edge index
			elif tile.get_edge(_c_free).get_tile_type() == -1:
				if is_tile_height_z(get_edge_z(tile, _c_free)): # Checking if null's height is valid
					_temp_tiles.append(_c_free) # Adding the free edge's edge index
			_c_free += 1
	
	return _temp_tiles.duplicate()

func add_tile(tile:DS_Tile) -> void:
	_free_edges = get_tile_free_edges(tile) # Getting all the free edges
	if _free_edges.is_empty(): return # Stopping process, No edges found
	set_processing(true) # Starting processing
	start_debug_timer() # Starting the debug timer
	
	_c_add1 = 0
	while _c_add1 < _free_edges.size(): # Loop for creating new edges from the free spots
		_tile_new1 = _get_temp_tile(tile, _free_edges[_c_add1]) # Getting the temp tile
		if _tile_new1 != null: _temp_grid.erase(_tile_new1) # Condition for finding a temp tile and removing it from the temp grid
		else: _tile_new1 = _create_tile(tile, _free_edges[_c_add1]) # Creating a new tile
		
		# Condition to check if the height
		if is_tile_height(_tile_new1):
			get_grid().add_tile(_tile_new1) # Adding new tile to the main grid
			add_tile_to_connect(_tile_new1)
			add_tile_to_process(_tile_new1) # Adding new tile to processing

			_c_add2 = 0
			while _c_add2 < _tile_new1.get_edge_size(): # Loop to create new edges from the main free edges
				_tile_new2 = _get_temp_tile(_tile_new1, _c_add2) # Getting the temp tile
				if _tile_new2 != null: add_tile_to_connect(_tile_new2) # Condition for adding existing tile to connect procesing
				else: # Condition for creating a new temp tile
					_tile_new2 = _create_tile(_tile_new1, _c_add2) # Creating a new temp tile
					if is_tile_height(_tile_new2): # Checking if temp tile's height is valid
						if !get_grid().has_tile_coord(_tile_new2) and !get_grid().has_tile_coord_grid(_tile_new2, _temp_grid): # Checking if the tile does NOT exist
							_temp_grid.append(_tile_new2) # Adding new tile to the temp grid
							add_tile_to_connect(_tile_new2) # Adding new tile to connect processing
				
				_c_add2 += 1
		_c_add1 += 1
	
	process_connect_tiles() # Starting connection processing
	reset_fail_safe() # Resetting fail safe
	process_main(false) # Starting processing without the need for searching for neighbours

func is_tile_height_z(height:int) -> bool: return super(height) if !_ignore_height else height >= 0

## This method creates a tile and returns it.
func _create_tile(tile:DS_Tile, edge:int) -> DS_Tile:
	_tile_temp = DS_Tile.new()
	_tile_temp.set_coord(
		get_edge_x(tile, edge), 
		get_edge_y(tile, edge),
		get_edge_z(tile, edge)
	)
	return _tile_temp

## This method gets the tile from the temp grid.
func _get_temp_tile(tile:DS_Tile, edge:int) -> DS_Tile:
	return get_grid().get_tile_coord_x_y_z_grid(
		get_edge_x(tile, edge), 
		get_edge_y(tile, edge),
		get_edge_z(tile, edge),
		_temp_grid
	)

# ## This method gets the x value for the edge tile.
# func _get_edge_x(tile:DS_Tile, edge:int) -> int:
# 	return (tile.get_x() + 1 if edge == 2 else
# 			tile.get_x() - 1 if edge == 5 else
# 			tile.get_x())

# ## This method gets the y value for the edge tile.
# func _get_edge_y(tile:DS_Tile, edge:int) -> int:
# 	return (tile.get_y() + 1 if edge == 4 else
# 			tile.get_y() - 1 if edge == 1 else
# 			tile.get_y())

# ## This method gets the z value for the edge tile.
# func _get_edge_z(tile:DS_Tile, edge:int) -> int:
# 	return (tile.get_z() + 1 if edge == 0 else
# 			tile.get_z() - 1 if edge == 3 else
# 			tile.get_z())
