@tool
class_name DS_InvalidComboData
extends Resource

@export_category("Invalid Combo Data")
@export var _self_rot:= 0
@export var _edge:= 0
@export var _type:= 0
@export var _rot:= 0
@export var _is_multi:= false

var _c1:= -1

func set_self_rot(self_rot:int) -> void: _self_rot = self_rot
func set_edge(edge:int) -> void: _edge = edge
func set_type(type:int) -> void: _type = type
func set_rot(rot:int) -> void: _rot = rot
func set_multi(is_multiple:bool) -> void: _is_multi = is_multiple

## This method sets all the data for the invalid combo data.
func set_ic_data(self_rot:int, edge:int, type:int, rot:int) -> void:
    set_self_rot(self_rot)
    set_edge(edge)
    set_type(type)
    set_rot(rot)

func get_self_rot() -> int: return _self_rot
func get_edge() -> int: return _edge
func get_type() -> int: return _type
func get_rot() -> int: return _rot
func is_multi() -> bool: return _is_multi

## This method resets the data to the default state.
func reset_data() -> void:
    _self_rot = 0
    _edge = 0
    _type = 0
    _rot = 0

## This method checks if the given DS_InvalidComboData is similar to the current one.
func is_equal_to(element: DS_InvalidComboData) -> bool:
    if _is_multi: # For multi check
        if element.get_type() == _type: # Checking if the edge type matches
            _c1 = 0 # Counter for going through all the rotation combinations
            while _c1 < 4: # Loop for going through all the rotation combinations
                if element.get_self_rot() == _get_correct_rot_value(_self_rot + _c1): # Checking if self rotation match found
                    return element.get_rot() == _get_correct_rot_value(_rot + _c1) and element.get_edge() == _get_correct_edge_value(_c1) # Checking and returning if edge and rotation matches
                _c1 += 1
    else: # For Single check
        return (element.get_self_rot() == _self_rot and element.get_edge() == _edge and
                element.get_type() == _type and element.get_rot() == _rot)
    return false

## This method gets the correct rotational value.
func _get_correct_rot_value(rot:int) -> int: return rot if rot < 4 else rot - 4

## This method gets the correct edge value by giving the counter value which from 0 to 3.
func _get_correct_edge_value(counter:int) -> int:
    if _edge == 1:
        return (
            1 if counter == 0 else 
            2 if counter == 1 else 
            4 if counter == 2 else 
            5
        )
    elif _edge == 2:
        return (
            2 if counter == 0 else 
            4 if counter == 1 else 
            5 if counter == 2 else 
            1
        )
    elif _edge == 4:
        return(
            4 if counter == 0 else 
            5 if counter == 1 else 
            1 if counter == 2 else 
            2
        )
    elif _edge == 5:
        return(
            5 if counter == 0 else 
            1 if counter == 1 else 
            2 if counter == 2 else 
            4
        )

    return _edge