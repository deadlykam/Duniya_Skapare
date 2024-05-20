@tool
# extends "res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_base.gd"
extends Control

# Constants
const DS_WFC_DATA: GDScript = preload("res://addons/kamran_wali/duniya_skapare/scripts/resources/ds_wfc_data.gd")
const DS_WFC_SETTINGS: GDScript = preload("res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_wfc_settings.gd")
const DS_TILE_RULES: GDScript = preload("res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_tile_rules.gd")
const DS_SAVE_LOAD: GDScript = preload("res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_save_load.gd")

# Properties from the scene
var _lbl_file_name: Label
var _msg_save: Label

# Properties for internal usage
var _data: DS_WFC_DATA = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse/default.tres")
var _wfc_settings: DS_WFC_SETTINGS
var _tile_rules: DS_TILE_RULES
var _save_load: DS_SAVE_LOAD
var _tile_edges: Control
var _counter1:= -1

func _enter_tree() -> void:
    _wfc_settings = $Main_Container/TabContainer/WFC_Settings
    _tile_rules = $Main_Container/TabContainer/Tile_Rules
    _save_load = $Save_Load_Container
    _tile_edges = $Main_Container/TabContainer/Tile_Rules/Holder/Tile_Edges
    _lbl_file_name = $Main_Container/FileNameContainer/Lbl_File_Name
    _msg_save = $Main_Container/FileNameContainer/Msg_Save

    _wfc_settings.set_main_ui(self)
    _save_load.set_main_ui(self)
    _tile_rules.set_main_ui(self)
    
    _counter1 = 0
    while _counter1 < _tile_edges.get_child_count(): # Loop for initializing the edge rule UIs
        _tile_edges.get_child(_counter1).set_main_ui(self)
        _counter1 += 1
    

## This method shows the unsaved message.
func show_unsaved_message(msg:String) -> void:
    _msg_save.text = msg
    _msg_save.visible = true

## This method sets up the UI.
func load_setup() -> void:
    _wfc_settings.setup()
    _tile_rules.setup()

## This method loads a new data.
func load_data(data: DS_WFC_Data) -> void:
    _data = data # Loading the data
    _lbl_file_name.text = _data.resource_path.get_file() # Showing the data file name

## This method gets the data.
func get_data() -> DS_WFC_Data: return _data

func _on_btn_save_pressed():
    _data.save()
    _msg_save.visible = false

func _on_btn_reset_pressed():
    _data.data_reset()
    _wfc_settings.reset() # Resetting wfc setting
    _tile_rules.setup() # Resetting the edges

func _on_btn_new_pressed(): _save_load.show_menu(true)
func _on_btn_load_pressed(): _save_load.show_menu(false)
func _on_tab_container_tab_changed(tab:int): if tab == 1: _tile_rules.setup() # Showing the tile rules tab