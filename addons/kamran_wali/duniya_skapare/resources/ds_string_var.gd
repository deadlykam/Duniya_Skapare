@tool
extends "res://addons/kamran_wali/duniya_skapare/resources/ds_base_resource.gd"

@export var _value: String

func set_value(value:String) -> void:
    _value = value

func get_value() -> String:
    return _value