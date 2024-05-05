@tool
extends Control

var _id:= -1
var _lbl_id: Label
var _txt_name: LineEdit

func _enter_tree():
    _lbl_id = $Holder/Lbl_ID
    _txt_name = $Holder/Txt_Name

## This method sets the id of the tile name UI.
func set_id(id:int) -> void:
    _id = id
    _set_label_id(str(_id))

## This method sets the lable id name.
func _set_label_id(id: String) -> void:
    _lbl_id.text = "Tile " + id