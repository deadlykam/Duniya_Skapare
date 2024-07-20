@tool
extends Control

const DS_WFC_SETTINGS: GDScript = preload("res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_wfc_settings.gd")

var _manager: DS_WFC_SETTINGS
var _id:= -1
var _lbl_id: Label
var _txt_name: LineEdit
var _name:= ""

func _enter_tree() -> void:
    _lbl_id = $Holder/Lbl_ID
    _txt_name = $Holder/Txt_Name
    _set_label_id()
    set_txt_name(_name)

## This method sets up the tile name UI.
func setup(manager:DS_WFC_SETTINGS, id:int) -> void:
    _manager = manager
    _id = id

## This method set the name of the tile.
func setup_name(name:String) -> void: _name = name

## This method sets the name of the text name.
func set_txt_name(name: String) -> void: _txt_name.text = name

func _on_txt_name_text_changed(new_text:String): _manager.update_tile_name_data(new_text, _id)

## This method sets the lable id name.
func _set_label_id() -> void: _lbl_id.text = "Tile " + str(_id) + ":"