@tool
class_name DS_String_Array_Var
extends "res://addons/kamran_wali/duniya_skapare/resources/ds_base_resource.gd"

@export var _data: Array[String]

## This method resets the data to the default state.
func data_reset() -> void:
    _data.resize(1)
    _data[0] = "Tile"

## This method updates the given element in the data.
func update_element(element:String, index:int) -> void:
    _data[index] = element

## This method gets an element.
func get_element(index:int) -> String:
    return _data[index]

## This method resizes the data.
func data_resize(size:int) -> void:
    _data.resize(size)

## This method gets the number of elements in the data.
func get_size() -> int:
    return _data.size()

## This method gets all the data by duplicating them.
func get_data() -> Array[String]:
    return _data.duplicate()