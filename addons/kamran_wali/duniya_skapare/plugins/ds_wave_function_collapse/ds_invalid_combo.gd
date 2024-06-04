@tool
extends "res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_base.gd"

# Properties from the scene
var _ob_tile_list: OptionButton
var _invalid_list: ItemList
var _ob_self_rot: OptionButton
var _ob_edge: OptionButton
var _ob_type: OptionButton
var _ob_rot: OptionButton

# Properties for internal usage
var _rules: Array[int]
var _tile:= -1
var _element_ic: DS_InvalidComboData
var _c1:= -1
var _index_exists:= -1
var _selected_items: PackedInt32Array

func _enter_tree() -> void:
    _ob_tile_list = $Holder/Tile_Selection_Container/OB_Tile_List
    _invalid_list = $Holder/Ignore_Combo_Container/Invalid_List
    _ob_self_rot = $Holder/Input_Container/OB_Self_Rot
    _ob_edge = $Holder/Input_Container/OB_Edge
    _ob_type = $Holder/Input_Container/OB_Type
    _ob_rot = $Holder/Input_Container/OB_Rot

## This method sets up the invalid combo tab.
func setup() -> void:
    _tile = 0 # Setting the starting tile to the first tile
    _invalid_list.deselect_all()
    _all_setup() # Calling all the setup for the first tile
    
    _ob_tile_list.clear()
    _c1 = 0
    # Loop to updating the tile list
    while _c1 < get_data().get_number_of_tiles():
        _ob_tile_list.add_item("(" + str(_c1) + ") " + get_data().get_tile_name(_c1))
        _c1 += 1

func _on_ob_tile_list_item_selected(index:int):
    if _tile != index:
        _tile = index
        _all_setup() # Calling all the setup for the given tile

func _on_btn_add_pressed():
    _element_ic = DS_InvalidComboData.new()
    _element_ic.set_self_rot(_ob_self_rot.selected)
    _element_ic.set_edge(_ob_edge.selected)
    _element_ic.set_type(_rules[_ob_type.selected])
    _element_ic.set_rot(_ob_rot.selected)
    _index_exists = get_data().get_invalid_combo_element_index(_tile, _element_ic) # Getting the index of existing element
    
    if _index_exists == -1: # Checking if the element does NOT exists already
        get_data().add_invalid_combo(_tile, _element_ic) # Adding new invalid rule
        _add_invalid_combo_list(_element_ic) # Adding new invalid combo data to the list
        get_main_ui().show_unsaved_message("Unsaved Changes!")
    else: _invalid_list.select(_index_exists) # Selecting the already existing element

func _on_btn_remove_pressed():
    _selected_items = _invalid_list.get_selected_items() # Getting all the selected items
    _c1 = _selected_items.size() - 1 # Starting from the last index
    while _c1 >= 0: # Loop for removing all the selected elements and items
        get_data().remove_invalid_combo_index(_tile, _selected_items[_c1]) # Removing element
        _invalid_list.remove_item(_selected_items[_c1]) # Removing item
        _c1 -= 1
    if !_selected_items.is_empty(): get_main_ui().show_unsaved_message("Unsaved Changes!")


## This method calls all the setup that is needed for a tile.
func _all_setup() -> void:
    _set_tile_rules() # Updating the rules
    _load_invalid_combo_list() # Loading all the invalid combo list

## This method loads all the invalid combo elements of the tile.
func _load_invalid_combo_list() -> void:
    _invalid_list.clear()
    _c1 = 0
    while _c1 < get_data().get_invalid_combo_element_size(_tile):
        _element_ic = get_data().get_invalid_combo_element(_tile, _c1)
        _add_invalid_combo_list(_element_ic)
        _c1 += 1

## This method adds a data to the invalid combo list.
func _add_invalid_combo_list(element: DS_InvalidComboData) -> void:
    _invalid_list.add_item(
        "Self Rot: " + str(element.get_self_rot() * 90) + ", " +
        "Edge: " + _get_edge_name(element.get_edge()) + ", " +
        "Type: " + "(" + str(element.get_type()) + ") " + get_data().get_tile_name(element.get_type()) + ", " +
        "Rot: " + str(element.get_rot() * 90)
    )

## This method sets the rule items.
func _set_tile_rules() -> void:
    _ob_type.clear()
    _rules = get_data().get_tile_rules(_tile) # Getting the rules for the tile
    _c1 = 0
    while _c1 < _rules.size(): # Loop for setting rule items
        _ob_type.add_item("(" + str(_rules[_c1]) + ") " + get_data().get_tile_name(_rules[_c1]))
        _c1 += 1

## This method gets the name of the edge.
func _get_edge_name(edge:int) -> String:
    return ("UP" if edge == 0 else 
            "NORTH" if edge == 1 else 
            "EAST" if edge == 2 else 
            "BOTTOM" if edge == 3 else 
            "SOUTH" if edge == 4 else 
            "WEST" if edge == 5 else 
            "ERROR")