@tool
extends "res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_base.gd"

# Constants
const DS_WFC_SETTINGS: GDScript = preload("res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_wfc_settings.gd")
const DS_TILE_RULES: GDScript = preload("res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_tile_rules.gd")
const DS_SAVE_LOAD: GDScript = preload("res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_save_load.gd")

# Properties from the scene
var _msg_save: Label

# Properties for internal usage
var _ds_wfc_settings: DS_WFC_SETTINGS
var _ds_tile_rules: DS_TILE_RULES
var _ds_save_load: DS_SAVE_LOAD
var _tile_edges: Control
var _counter1:= -1

func _enter_tree() -> void:
    _ds_wfc_settings = $Main_Container/TabContainer/WFC_Settings
    _ds_tile_rules = $Main_Container/TabContainer/Tile_Rules
    _ds_save_load = $Save_Load_Container
    _tile_edges = $Main_Container/TabContainer/Tile_Rules/Holder/Tile_Edges
    _msg_save = $Main_Container/ButtonContainer/Msg_Save

    _ds_wfc_settings.init(self)
    
    _counter1 = 0
    while _counter1 < _tile_edges.get_child_count(): # Loop for initializing the edge rule UIs
        _tile_edges.get_child(_counter1).init(self)
        _counter1 += 1

## This method shows the unsaved message.
func show_unsaved_message(msg:String) -> void:
    _msg_save.text = msg
    _msg_save.visible = true

func _on_btn_save_pressed():
    get_data()._data_wfc_not.save()
    get_data()._data_wfc_names.save()
    get_data()._data_wfc_rules.save()
    _msg_save.visible = false

func _on_btn_reset_pressed():
    get_data()._data_wfc_not.set_value(1)
    get_data()._data_wfc_names.data_reset()
    get_data()._data_wfc_rules.data_reset()
    _ds_wfc_settings.reset() # Resetting wfc setting
    _ds_tile_rules.setup() # Resetting the edges

func _on_btn_save_as_pressed():
    _ds_save_load.show_menu(true)

func _on_btn_load_pressed():
    _ds_save_load.show_menu(false)

func _on_tab_container_tab_changed(tab:int):
    if tab == 1: # Condition to show the tile rules tab
        _ds_tile_rules.setup()