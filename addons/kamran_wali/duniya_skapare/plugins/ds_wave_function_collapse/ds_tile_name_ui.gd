@tool
extends Control

const DS_WFC_SETTINGS: GDScript = preload("res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_wfc_settings.gd")

var _manager: DS_WFC_SETTINGS
var _id:= -1
var _lbl_id: Label
var _txt_name: LineEdit

func _enter_tree():
    _lbl_id = $Holder/Lbl_ID
    _txt_name = $Holder/Txt_Name
    _set_label_id(str(_id))

## This method sets up the tile name UI.
func setup(manager:DS_WFC_SETTINGS, id:int) -> void:
    _manager = manager
    _id = id

## This method sets the lable id name.
func _set_label_id(id: String) -> void:
    _lbl_id.text = "Tile " + id + ":"