@tool
extends "res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_base.gd"

# Constants
const DS_TILE_RULES: GDScript = preload("res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_tile_rules.gd")
const DS_WFC_SAVE: GDScript = preload("res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_wfc_save.gd")

var _ds_wfc_save: DS_WFC_SAVE
var _ds_tile_rules: DS_TILE_RULES
var _tile_edges: Control
var _counter1:= -1

func _enter_tree() -> void:
    _ds_wfc_save = $Main_Container/Save_Container
    _ds_tile_rules = $Main_Container/TabContainer/Tile_Rules
    _tile_edges = $Main_Container/TabContainer/Tile_Rules/Holder/Tile_Edges

    _counter1 = 0
    while _counter1 < _tile_edges.get_child_count(): # Loop for initializing the edge rule UIs
        _tile_edges.get_child(_counter1).init(_ds_wfc_save)
        _counter1 += 1

func _on_tab_container_tab_changed(tab:int):
    if tab == 1: # Condition to show the tile rules tab
        _ds_tile_rules.setup()
