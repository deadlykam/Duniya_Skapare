@tool
extends "res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_base.gd"

# Constants
const DS_EDGE_RULE_UI: GDScript = preload("res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_edge_rule_ui.gd")

# Properties from the scene
var _ob_tile_list: OptionButton
var _tile_edges: Control

# Properties for internal usage
var _edges: Array[DS_EDGE_RULE_UI]
var _counter:= -1
var _counter_method1:= -1

func _enter_tree() -> void:
    _ob_tile_list = $Holder/Tile_Selection_Container/OB_Tile_List
    _tile_edges = $Holder/Tile_Edges

    _counter = 0
    while _counter < _tile_edges.get_child_count(): # Loop for adding all the edge scripts
        _edges.append(_tile_edges.get_child(_counter))
        _counter += 1

func setup() -> void:
    _ob_tile_list.clear()
    _counter = 0
    
    # Loop to update the option list with the tile names
    while _counter < get_data().get_wfc_data().get_number_of_tiles():
        _ob_tile_list.add_item(get_data().get_wfc_data().get_tile_name(_counter))
        _counter += 1
    
    _update_tile_edges_tile_list() # Updating tile edges tile names
    _update_tile_edges_info(0) # Updating tile edges' info to the first tile

func _on_ob_tile_list_item_selected(index:int):
    _update_tile_edges_info(index)

## This method updates the tile list names for the edges'
func _update_tile_edges_tile_list() -> void:
    _counter_method1 = 0
    while _counter_method1 < _edges.size(): # Loop to update the edges' tile list
        _edges[_counter_method1].setup() # Updating the list
        _counter_method1 += 1

## This method updates the tile edges info to reflect the selected tile's edges.
func _update_tile_edges_info(tile:int) -> void:
    _counter_method1 = 0
    while _counter_method1 < _edges.size(): # Loop to update the edges' tile list
        _edges[_counter_method1].setup_tile_list(tile)
        _counter_method1 += 1