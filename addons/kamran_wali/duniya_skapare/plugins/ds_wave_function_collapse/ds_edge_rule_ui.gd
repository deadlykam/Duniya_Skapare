@tool
extends "res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_base.gd"

@export_category("DS Edge Rule UI")
@export var _edge_name:= ""
@export_range(0, 5) var _index_edge:= 0

# Properties from the scene
var _lbl_edge: Label
var _tile_list: ItemList
var _btn_add: Button
var _btn_remove: Button

# Properties for interal usage
var _tile:= -1
var _tile_names: Array[String]
var _rules: Array[int]
var _selected_items: PackedInt32Array
var _counter1:= -1
var _counter2:= -1
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
    
    _rules = get_data()._data_wfc_rules.get_edge_rules(_tile, _index_edge) # Getting all the rules
    _counter1 = 0 # Acting as the tile index
    while _counter1 < _tile_names.size(): # Loop for finding all the rules item
        _set_item_colour(_counter1, _red) # Making item red at first
        _counter2 = 0
        while _counter2 < _rules.size(): # Loop to check if the item is a rule
            if _counter1 == _rules[_counter2]: # Condition for finding a rule
                _set_item_colour(_counter1, _green) # Making item green
                break
            _counter2 += 1
        _counter1 += 1

## This method sets the colour of the indexth item.
func _set_item_colour(index:int, colour:Color) -> void:
    _tile_list.set_item_custom_bg_color(index, colour)