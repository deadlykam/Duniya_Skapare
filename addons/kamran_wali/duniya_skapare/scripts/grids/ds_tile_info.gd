@tool
class_name DS_TileInfo
extends Resource

@export var _is_fixed: bool
var _rot_value: int
var _type: int
var _index: int:
    set(p_index):
        if _index != p_index:
            _index = p_index
            _update_all_property_list()

var _id:= -1
var _data: Array[DS_TileInfo]
var _names: Array[String]
var _grid_size:= -1
var _type_names: String
var _grid_pos_names: String
var _counter: int
var _c_data: int
var _c_property: int

func _get_property_list():
    var properties = []

    if _names != null:
        if _names.size() != 0:
            _type_names = ""
            _counter = 0

            # Loop for loading up all the tile type names
            while _counter < _names.size():
                _type_names += (
                    "(" + str(_counter) + ") " + _names[_counter] + (
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

        while _counter < _grid_size: # Loop for loading up all the tile index
            _c_data = 0

            while _c_data < _data.size(): # Loop to check if an index has been selected
                if _data[_c_data] != null: # Checking if the data is NOT null
                    if _data[_c_data].get_index() == _counter && _c_data != _id:
                        break
                _c_data += 1
            
            _grid_pos_names += (
                (
                    str(_counter) if _c_data == _data.size() else (str(_counter) + " -> Sel By " + str(_c_data))
                )
                + 
                (
                    "," if _counter < _grid_size - 1 
                    else ""
                )
            )
            _counter += 1
        
        _counter = 0
        
        # Showing the index as enums
        properties.append({
            "name" : "_index",
            "type" : TYPE_INT,
            "hint" : PROPERTY_HINT_ENUM,
            "hint_string" : _grid_pos_names
        })
    
    # Showing the rotations as degrees
        properties.append({
            "name" : "_rot_value",
            "type" : TYPE_INT,
            "hint" : PROPERTY_HINT_ENUM,
            "hint_string" : "0, 90, 180, 270"
        })
    
    return properties

## This method sets the data for the Tile Info.
func set_data(data:Array[DS_TileInfo], names: Array[String], grid_size:int, id:int) -> void:
    _data = data
    _names = names
    _grid_size = grid_size
    _id = id

## This method gets the rot value.
func get_rot_value() -> int: return _rot_value

## This checks if the fixed or NOT.
func is_fixed() -> bool: return _is_fixed

## This method gets the type.
func get_type() -> int: return _type

## This method gets the index.
func get_index() -> int: return _index

## This method updates the property list.
func update_property_list() -> void: notify_property_list_changed()

## This method updates the property list of all the tile infos.
func _update_all_property_list() -> void:
    _c_property = 0

    while _c_property < _data.size(): # Loop for updating all the property list of all tile infos
        if _data[_c_property] != null:
            _data[_c_property].update_property_list() # Calling property update
        _c_property += 1