@tool
extends "res://addons/kamran_wali/duniya_skapare/scripts/stage_generators/ds_wfc_gen.gd"

# Properties for internal usage ONLY
var _tiles_connect: Array[DS_Tile]
var _tile_new1: DS_Tile
var _tile_new2: DS_Tile
var _tile_temp: DS_Tile
var _temp_tiles: Array[int]
var _c_free:= -1
var _c_add1:= -1
var _c_add2:= -1

func tile_free_edges(tile:int) -> Array[int]:
	if get_grid().get_tile(tile) != null: # Checking if the tile exists
		_temp_tiles.clear() # Clearing previous data
		_c_free = 0
		while _c_free < get_grid().get_tile(tile).get_edge_size(): # Loop for getting all the free edges
			if get_grid().get_tile(tile).get_edge(_c_free) == null: # Checking if free edge found
				_temp_tiles.append(_c_free) # Adding the free edge's edge index
			_c_free += 1
	
	return _temp_tiles.duplicate()

func add_tile(tile:int, free_edges:Array[int]) -> void:
	_c_add1 = 0
	while _c_add1 < free_edges.size(): # Loop for creating new edges from the free spots
		_tile_new1 = _create_tile(get_grid().get_tile(tile), free_edges[_c_add1]) # Creating a new tile
		get_grid().add_tile(_tile_new1) # Adding new tile to the grid
		_tiles_connect.append(_tile_new1) # Adding new tile to connect processing
		add_tile_to_process(_tile_new1) # Adding ne tile to processing

		_c_add2 = 0
		while _c_add2 < _tile_new1.get_edge_size(): # Loop to create new edges from the main free edges
			_tile_new2 = _create_tile(_tile_new1, _c_add2) # Creating a new tile
			if !get_grid().has_tile_coord(_tile_new2): # Checking if the tile does NOT exist
				get_grid().add_tile(_tile_new2) # Adding new tile to the grid
				_tiles_connect.append(_tile_new2) # Adding new tile to connect processing
				add_tile_to_process(_tile_new2) # Adding ne tile to processing
			_c_add2 += 1

		_c_add1 += 1
	
	while !_tiles_connect.is_empty(): # Loop for connecting all the newly added tiles
		_tile_new1 = _tiles_connect.pop_front() # Getting the tile

		_c_add1 = 0
		while _c_add1 < _tile_new1.get_edge_size(): # Loop to check all the edges of the tile for matches
			_tile_new2 = get_grid().get_tile_coord_x_y_z( # Getting the neighbouring tile using coordinates
				_tile_new1.get_x() + 1 if _c_add1 == 2 else
				_tile_new1.get_x() - 1 if _c_add1 == 5 else
				_tile_new1.get_x(),
				_tile_new1.get_y() + 1 if _c_add1 == 4 else
				_tile_new1.get_y() - 1 if _c_add1 == 1 else
				_tile_new1.get_y(),
				_tile_new1.get_z() + 1 if _c_add1 == 0 else
				_tile_new1.get_z() - 1 if _c_add1 == 3 else
				_tile_new1.get_z())
			
			if _tile_new2 != null: # Checking if neighbour found
				_tile_new1.set_edge(_tile_new2, _c_add1) # Adding neighbour to current
				_tile_new2.set_edge(_tile_new1, get_edge_opposite_index(_c_add1, _tile_new2.get_edge_size())) # Adding curring to neighbour
			
			_c_add1 += 1
	
	# TODO: Start the tile processing with flag for adding to tiles to open tile array

func _is_tile_coord(tile:DS_Tile, edge:int) -> bool:
	return get_grid().ha

## This method creates a tile and returns it.
func _create_tile(tile:DS_Tile, edge:int) -> DS_Tile:
	_tile_temp = DS_Tile.new()
	_tile_temp.set_coord( # Setting the coordinate
		tile.get_x() + 1 if edge == 2 else
		tile.get_x() - 1 if edge == 5 else
		tile.get_x(),
		tile.get_y() + 1 if edge == 4 else
		tile.get_y() - 1 if edge == 1 else
		tile.get_y(),
		tile.get_z() + 1 if edge == 0 else
		tile.get_z() - 1 if edge == 3 else
		tile.get_z()
	)
	return _tile_temp