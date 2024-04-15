@tool
class_name DS_FixedCheckBoxFlagArray
extends "res://addons/kamran_wali/scripts/resources/ds_base_resource.gd"

@export var _data: Array[bool]
var _sum:= 0
var _counter:= 0

## This method finds the minimum index.
func _get_min_index(index:int) -> int:
    _sum = 0
    _counter = 0

    while _counter <= index: # Loop for finding the minimum index
        _sum += _counter
        _counter += 1

    return _sum

## This method updates the element.
func update_element(index_main:int, index_pos:int, toggle:bool) -> void:
    _data[_get_min_index(index_main) + index_pos] = toggle

## This method gets the element.
func get_element(index_main:int, index_pos:int) -> bool:
    return _data[_get_min_index(index_main) + index_pos]