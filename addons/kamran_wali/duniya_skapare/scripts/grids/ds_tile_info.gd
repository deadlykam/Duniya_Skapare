@tool
class_name DS_TileInfo
extends Resource

@export_range(0, 3) var _rot_value: int
@export var _is_fixed: bool
var _type: int
var _index: int

var _names: Array[String]
var _grid_size:= -1
var _type_names: String
var _grid_pos_names: String
var _counter: int

func _get_property_list():
    var properties = []

    if _names != null:
        if _names.size() != 0:
            _type_names = ""
            _counter = 0

            # Loop for loading up all the tile type names
            while _counter < _names.size():
                _type_names += (
                    _names[_counter] + (
                        "," if _counter < _names.size() - 1
                        else ""
                    )
                )
                _counter += 1
            
            properties.append({
                "name" : "_type",
                "type" : TYPE_INT,
                "hint" : PROPERTY_HINT_ENUM,
                "hint_string" : _type_names
            })
    
    if _grid_size != -1:
        _grid_pos_names = ""
        _counter = 0

        while _counter < _grid_size: # Loop fro loading up all the tile index
            _grid_pos_names += (
                str(_counter) + (
                    "," if _counter < _grid_size - 1 
                    else ""
                )
            )
            _counter += 1
			
        # Showing the names as enums
        properties.append({
            "name" : "_index",
            "type" : TYPE_INT,
            "hint" : PROPERTY_HINT_ENUM,
            "hint_string" : _grid_pos_names
        })
    
    return properties

## This method sets the data for the Tile Info.
func set_data(names: Array[String], grid_size:int) -> void:
    _names = names
    _grid_size = grid_size

## This method gets the rot value.
func get_rot_value() -> int: return _rot_value

## This checks if the fixed or NOT.
func is_fixed() -> bool: return _is_fixed

## This method gets the type.
func get_type() -> int: return _type

## This method gets the index.
func get_index() -> int: return _index