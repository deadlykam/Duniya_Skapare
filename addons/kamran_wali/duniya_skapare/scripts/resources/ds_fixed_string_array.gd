@tool
extends "res://addons/kamran_wali/duniya_skapare/scripts/resources/ds_base_resource.gd"

@export var _data: Array[String]

## This method updates the given element in the data.
func update_element(element:String, index:int) -> void:
    _data[index] = element

## This method gets an element.
func get_element(index:int) -> String:
    return _data[index]

## This method gets the number of elements in the data.
func get_size() -> int:
    return _data.size()

## This method gets all the data by duplicating
## all the data.
func get_data() -> Array[String]:
    return _data.duplicate()