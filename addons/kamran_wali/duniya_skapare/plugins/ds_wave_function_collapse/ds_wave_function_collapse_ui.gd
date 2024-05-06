@tool
extends "res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_base.gd"

# Constants
const DS_TILE_RULES: GDScript = preload("res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_tile_rules.gd")

var _ds_tile_rules: DS_TILE_RULES

func _enter_tree() -> void:
    _ds_tile_rules = $Main_Container/TabContainer/Tile_Rules

func _on_tab_container_tab_changed(tab:int):
    if tab == 1: # Condition to show the tile rules tab
        _ds_tile_rules.setup()
