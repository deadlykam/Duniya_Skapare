@tool
class_name DS_FixedStringArray
extends "res://addons/kamran_wali/scripts/resources/ds_base_resource.gd"

@export var _data: Array[String]

## This method updates the given element in the data.
func update_element(element:String, index:int) -> void:
    _data[index] = element

## This method gets an element.
func get_element(index:int) -> String:
    return _data[index]