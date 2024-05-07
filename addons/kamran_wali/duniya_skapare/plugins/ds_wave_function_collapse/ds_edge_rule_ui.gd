@tool
extends "res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_base.gd"

@export_category("DS Edge Rule UI")
@export var _edge_name:= ""

# Properties from the scene
var _lbl_edge: Label
var _tile_list: ItemList
var _btn_add: Button
var _btn_remove: Button

# Properties for interal usage
var _tile:= -1
var _tile_names: Array[String]
var _selected_items: PackedInt32Array
var _counter1:= -1
var _green: Color
var _red: Color
var _alpha:= 0.125

func _enter_tree() -> void:
    _lbl_edge = $Lbl_Edge
    _tile_list = $Tile_List
    _btn_add = $Btn_Add
    _btn_remove = $Btn_Remove

    _lbl_edge.text = _edge_name
    _green = Color.GREEN
    _red = Color.RED
    _green.a = _alpha
    _red.a = _alpha

## This method sets up the UI with the given tile
func setup(tile:int) -> void:
    # TODO: Load the tile's rules as well and highlight the correct ones.
    _tile = tile
    _setup_tile_list() # Showing tile lists

## This method shows the edge's tile lists.
func _setup_tile_list() -> void:
    _tile_list.clear()
    _tile_names = get_data().get_wfc_tile_names()

    _counter1 = 0
    while _counter1 < _tile_names.size(): # Loop for adding all the items
        _tile_list.add_item(_tile_names[_counter1])
        _counter1 += 1
    
    # TODO: Show the correct tile type added or removed by setting the colour