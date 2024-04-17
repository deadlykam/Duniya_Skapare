@tool
class_name DS_Grid
extends Node

@export_category("Grid")
@export_group("Size")
@export var _grid_x:= 3
@export var _grid_y:= 3
@export_group("Starting Tile")
@export var _index_start_tile:= 0
var _start_tile_type: int

# Data Properties
var _data_names: DS_FixedStringArray = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse_settings/data_names.tres")

var _tiles: Array[DS_Tile]
var _tile_current: DS_Tile
var _index:= -1
var _counter1:= -1
var _counter2:= -1
var _type_names: String

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
    _counter1 = 0

    # Loop for initiating tiles
    while _counter1 < (_grid_x * _grid_y):
        _tiles.append(DS_Tile.new()) # Adding initiated tiles
        _counter1 += 1
    
    # Setting the starting tile
    _tile_current = _tiles[_index_start_tile]
    _tile_current.set_type(_start_tile_type)

    _index = 0
    _counter1 = 0 # Y-axis counter

    while _counter1 < _grid_y: # Loop for going through y-axis tiles
        _counter2 = 0 # X-axis counter
        
        while _counter2 < _grid_x: # Loop for going through x-axis tiles

            # Adding north tile refs
            _tiles[_index].set_north(
                _tiles[_index - _grid_y] if
                _counter1 > 0 #&& (_counter1 <= _grid_y - 1)
                else null
            )
            
            # Adding sourth tile refs
            _tiles[_index].set_south(
                _tiles[_index + _grid_y] if
                _counter1 < _grid_y - 1
                else null
            )
            
            # Adding west tile refs
            _tiles[_index].set_west(
                _tiles[_index - 1] if
                _counter2 > 0 #&& (_counter2 <= _grid_x - 1)
                else null
            )
            
            # Adding east tile refs
            _tiles[_index].set_east(
                _tiles[_index + 1] if 
                _counter2 < _grid_x - 1
                else null
            )
            
            _index += 1
            _counter2 += 1
        _counter1 += 1