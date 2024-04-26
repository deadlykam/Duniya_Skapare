@tool
extends Control

var _manager: DS_WFCSetup
var _id:= -1
var _lbl_id: Label
var _txt_name: LineEdit

func _enter_tree() -> void:
    _lbl_id = $Label_ID
    _txt_name = $Txt_Name

func _on_txt_name_text_changed(name:String):
    _manager.update_name(name, _id)

## This method sets the name of the text name line edit.
func set_txt_name(name:String) -> void:
    _txt_name.text = name

## This method sets the id of the label.
func set_label_id() -> void:
    _lbl_id.text = "Object" + str(_id) + ":"

## This method sets the manager
func set_manager(manager:DS_WFCSetup) -> void:
    _manager = manager

## This method sets the id of name input.
func set_id(id:int) -> void:
    _id = id

## This method gets the id of the name input.
func get_id() -> int:
    return _id