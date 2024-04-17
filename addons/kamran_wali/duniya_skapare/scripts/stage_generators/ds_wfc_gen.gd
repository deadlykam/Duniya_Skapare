@tool
class_name DS_WFCGen
extends Node

@export_category("Wave Function Collapse")
@export var _grid: DS_Grid
@export var _index_start_tile:= 0
var _start_tile_type: int

# Data Properties
var _data_names: DS_FixedStringArray = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse_settings/data_names.tres")
var _data_checkboxes: DS_FixedCheckBoxFlagArray = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse_settings/data_checkboxes.tres")

var _tiles_open: Array[DS_Tile]
var _tiles_closed: Array[DS_Tile]
var _tile_current: DS_Tile
var _type_names: String
var _counter1:= -1

func _get_property_list():
    var properties = []

    _type_names = ""
    _counter1 = 0
    # Loop for loading up all the type names
    while _counter1 < _data_names.get_size():
        _type_names += (_data_names.get_element(_counter1) + 
            ("," if _counter1 < _data_names.get_size() - 1 else ""))
        _counter1 += 1

    # Showing the names as enums
    properties.append({
        "name" : "_start_tile_type",
        "type" : TYPE_INT,
        "hint" : PROPERTY_HINT_ENUM,
        "hint_string" : _type_names
    })

    return properties

func _ready() -> void:
    _tiles_open.clear()
    _tiles_closed.clear()

    # Setting the starting tile
    _tile_current = _grid.get_tile(_index_start_tile)
    _tile_current.set_type(_start_tile_type)

    _counter1 = 0

    # Loop for adding all the cardinal directions for process
    while _counter1 < _tile_current.get_cardinal_direction_size():
        if _tile_current.get_cardinal_direction(_counter1) != null:
            _tiles_open.append(
                _tile_current.get_cardinal_direction(_counter1)
                )
    
    _tiles_closed.append(_tile_current) # Closing the first processed tile

    # Loop for processing all the tiles
    while !_tiles_open.is_empty():
        _tile_current = _tiles_open.pop_front() # Getting next tile
        _counter1 = 0 # Cardinal Direction counter

        # Loop for going through all the cardinal directions
        while _counter1 < _tile_current.get_cardinal_direction_size():
            # Condition for finding a cardinal direction
            if _tile_current.get_cardinal_direction(_counter1) != null:
                # TODO: Add the types
                pass