@tool
class_name DS_Int_Var
extends "res://addons/kamran_wali/duniya_skapare/resources/ds_base_resource.gd"

@export var _value:= 0

## Setting the value.
func set_value(value:int) -> void:
    _value = value

## Getting the value.
func get_value() -> int:
    return _value