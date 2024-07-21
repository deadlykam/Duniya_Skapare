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

## This method sets up the UIs name list
func setup() -> void:
    _tile_list.clear()
    _tile_names = get_data().get_tile_names()

    _counter1 = 0
    while _counter1 < _tile_names.size(): # Loop for adding all the items
        _tile_list.add_item("(" + str(_counter1) + ") " + _tile_names[_counter1])
        _counter1 += 1

## This method shows the edge's tile lists.
func setup_tile_list(tile:int) -> void:
    _tile_list.deselect_all()
    _tile = tile
    _rules = get_data().get_edge_rules(_tile, _index_edge) # Getting all the rules
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

func _on_btn_add_pressed():
    _selected_items = _tile_list.get_selected_items()
    _counter1 = 0

    while _counter1 < _selected_items.size(): # Loop for adding edge rules
        if !get_data().has_rule_element(_tile, _selected_items[_counter1], _index_edge): # Checking if rule NOT added
            get_data().add_edge_rule(_tile, _selected_items[_counter1], _index_edge) # Adding the rule
            _set_item_colour(_selected_items[_counter1], _green)
        _counter1 += 1
    
    get_main_ui().show_unsaved_message("Unsaved Changes!")

func _on_btn_remove_pressed():
    _selected_items = _tile_list.get_selected_items()
    _counter1 = 0

    while _counter1 < _selected_items.size(): # Loop for removing edge rules
        get_data().remove_edge_rule_element(_tile, _selected_items[_counter1], _index_edge) # Removing the rule
        _set_item_colour(_selected_items[_counter1], _red)
        _counter1 += 1
    
    get_main_ui().show_unsaved_message("Unsaved Changes!")

## This method sets the colour of the indexth item.
func _set_item_colour(index:int, colour:Color) -> void:
    _tile_list.set_item_custom_bg_color(index, colour)