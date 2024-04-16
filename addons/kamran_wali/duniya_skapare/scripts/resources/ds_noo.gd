@tool
class_name DS_NoO
extends "res://addons/kamran_wali/duniya_skapare/scripts/resources/ds_base_resource.gd"

@export var _value:= 0

func set_value(value:int) -> void:
    _value = value

func get_value() -> int:
    return _value