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
var _counter1:= -1
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
    
    print(_start_tile_type)