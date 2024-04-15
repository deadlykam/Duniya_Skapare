@tool
extends Control

var _manager: DS_PluginSetup
var _btn_check: Button
var _id_main:= -1 # Main array
var _id_pos:= -1 # Array position in the main array

func _enter_tree() -> void:
	_btn_check = $Btn_Check
	
func _on_btn_check_toggled(button_pressed:bool):
	_manager.update_check_box(_id_main, _id_pos, _btn_check.button_pressed)

## This method sets up the check box data object.
func setup(manager:DS_PluginSetup, id_main:int, id_pos:int, toggle:bool) -> void:
	_manager = manager
	_id_main = id_main
	_id_pos = id_pos
	_btn_check.button_pressed = toggle
