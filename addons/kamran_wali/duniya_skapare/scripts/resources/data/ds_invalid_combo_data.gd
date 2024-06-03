class_name DS_InvalidComboData
extends Resource

@export_category("Invalid Combo Data")
@export var _self_rot:= 0
@export var _edge:= 0
@export var _type:= 0
@export var _rot:= 0

func set_self_rot(self_rot:int) -> void: _self_rot = self_rot
func set_edge(edge:int) -> void: _edge = edge
func set_type(type:int) -> void: _type = type
func set_rot(rot:int) -> void: _rot = rot

func get_self_rot() -> int: return _self_rot
func get_edge() -> int: return _edge
func get_type() -> int: return _type
func get_rot() -> int: return _rot

## This method checks if the given DS_InvalidComboData is similar to the current one.
func is_equal_to(data: DS_InvalidComboData) -> bool:
    return (data.get_self_rot() == _self_rot and data.get_edge() == _edge and
            data.get_type() == _type and data.get_rot() == _rot)