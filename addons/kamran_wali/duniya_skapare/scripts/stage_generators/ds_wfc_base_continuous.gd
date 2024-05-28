@tool
extends "res://addons/kamran_wali/duniya_skapare/scripts/stage_generators/ds_wfc_gen.gd"

var _tiles_connect: Array[DS_Tile]
var _tile_connect: DS_Tile
var _tile_searched: DS_Tile
var _c_connect:= -1

## This method adds the tile to connect array for processing.
func add_tile_to_connect(tile:DS_Tile) -> void: _tiles_connect.append(tile)

## This method handles the newly added tile connection processing.
func process_connect_tiles() -> void:
    while !_tiles_connect.is_empty(): # Loop for connecting all the newly added tiles
        _tile_connect = _tiles_connect.pop_front() # Getting the tile to connect

        _c_connect = 0
        while _c_connect < _tile_connect.get_edge_size(): # Loop to check all the edges of the tile for matches
            _tile_searched = get_grid().get_tile_coord_x_y_z( # Getting the neighbouring tile using coordinates in main grid
                get_edge_x(_tile_connect, _c_connect),
                get_edge_y(_tile_connect, _c_connect),
                get_edge_z(_tile_connect, _c_connect))
        
            if _tile_searched != null: # Checking if neighbour found
                _tile_connect.set_edge(_tile_searched, _c_connect) # Adding neighbour to current
                _tile_searched.set_edge(_tile_connect, get_edge_opposite_index(_c_connect, _tile_searched.get_edge_size())) # Adding current to neighbourk
            _c_connect += 1

## This method gets the x value for the edge tile.
func get_edge_x(tile:DS_Tile, edge:int) -> int:
    return (tile.get_x() + 1 if edge == 2 else
			tile.get_x() - 1 if edge == 5 else
			tile.get_x())

## This method gets the y value for the edge tile.
func get_edge_y(tile:DS_Tile, edge:int) -> int:
    return (tile.get_y() + 1 if edge == 4 else
			tile.get_y() - 1 if edge == 1 else
			tile.get_y())

## This method gets the z value for the edge tile.
func get_edge_z(tile:DS_Tile, edge:int) -> int:
    return (tile.get_z() + 1 if edge == 0 else
			tile.get_z() - 1 if edge == 3 else
			tile.get_z())