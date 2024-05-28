@tool
extends "res://addons/kamran_wali/duniya_skapare/scripts/stage_generators/ds_wfc_base_continuous.gd"

# Properties for internal usage ONLY
var _tile_new: DS_Tile
var _x_min:= -1
var _x_max:= -1
var _y_min:= -1
var _y_max:= -1
var _z_min:= -1
var _z_max:= -1
var _c_x:= -1
var _c_y:= -1
var _c_z:= -1

func setup() -> void:
    super()
    _x_min = 0
    _x_max = get_grid().get_grid_size_x()
    _y_min = 0
    _y_max = get_grid().get_grid_size_y()
    _z_min = 0
    _z_max = get_grid().get_grid_size_z()

func expand_grid(dir:int) -> void:
    # TODO: First do for North only.
    # TODO: Get the minimum x and y coordinates for North
    # TODO: When expanding north subtract from y min value
    set_processing(true) # Starting processing
    start_debug_timer() # Starting the debug timer

    if dir == 1:
        # NORTH
        _c_z = 0
        while _c_z <= _z_max: # Loop for going through z coordinates
            _c_y = _y_min - 1 # Starting from new coordinates
            while _c_y > _y_min - get_grid().get_grid_size_y() - 1: # Loop for going through y coordinates
                _c_x = _x_min
                while _c_x < _x_max: # Loop for going through x coordinates
                    _tile_new = DS_Tile.new() # Creating a new tile
                    _tile_new.set_coord(_c_x, _c_y, _c_z) # Setting new tile's coordinates
                    get_grid().add_tile(_tile_new) # Adding new tile to the main grid
                    add_tile_to_connect(_tile_new) # Adding tile to connection processing
                    add_tile_to_process(_tile_new) # Adding tile to main processing
                    _c_x += 1
                _c_y -= 1
            _c_z += 1
        _y_min -= get_grid().get_grid_size_y() # Updating y min
    
    if dir == 4:
        # SOUTH
        _c_z = 0
        while _c_z <= _z_max: # Loop for going through z coordinates
            _c_y = _y_max # Starting from new coordinates
            while _c_y < _y_max + get_grid().get_grid_size_y(): # Loop for going through y coordinates
                _c_x = _x_min
                while _c_x < _x_max: # Loop for going through x coordinates
                    _tile_new = DS_Tile.new() # Creating a new tile
                    _tile_new.set_coord(_c_x, _c_y, _c_z) # Setting new tile's coordinates
                    get_grid().add_tile(_tile_new) # Adding new tile to the main grid
                    add_tile_to_connect(_tile_new) # Adding tile to connection processing
                    add_tile_to_process(_tile_new) # Adding tile to main processing
                    _c_x += 1
                _c_y += 1
            _c_z += 1
        _y_max += (get_grid().get_grid_size_y()) # Updating y max
    
    if dir == 2:
        # EAST
        _c_z = 0
        while _c_z <= _z_max:
            _c_y = _y_min
            while _c_y < _y_max:
                _c_x = _x_min - 1
                while _c_x > _x_min - get_grid().get_grid_size_x() - 1:
                    _tile_new = DS_Tile.new() # Creating a new tile
                    _tile_new.set_coord(_c_x, _c_y, _c_z) # Setting new tile's coordinates
                    get_grid().add_tile(_tile_new) # Adding new tile to the main grid
                    add_tile_to_connect(_tile_new) # Adding tile to connection processing
                    add_tile_to_process(_tile_new) # Adding tile to main processing
                    _c_x -= 1
                _c_y += 1
            _c_z += 1
        _x_min -= get_grid().get_grid_size_x()
    
    process_connect_tiles() # Starting connection processing
    reset_fail_safe() # Resetting fail safe
    process_main(false) # Starting processing without the need searching for neighbours
    # _DELETE_ME()

func _DELETE_ME() -> void:
    var c = 0
    while c < get_grid().get_tiles_size():
        print("Tile ", c, ": (", get_grid().get_tile(c).get_x(), ", ", get_grid().get_tile(c).get_y(), ", ", get_grid().get_tile(c).get_z())
        c += 1