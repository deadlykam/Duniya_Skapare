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
var _c1 = -1

func _enter_tree() -> void:
    _ob_tile_list = $Holder/Tile_Selection_Container/OB_Tile_List
    _invalid_list = $Holder/Ignore_Combo_Container/Invalid_List
    _ob_self_rot = $Holder/Input_Container/OB_Self_Rot
    _ob_edge = $Holder/Input_Container/OB_Edge
    _ob_type = $Holder/Input_Container/OB_Type
    _ob_rot = $Holder/Input_Container/OB_Rot

    # _c1 = 0
    # while _c1 < 3:
    #     _rules = get_data().get_tile_rules(_c1)
    #     print("Tile ", _c1, " Rules: ", _rules)
    #     _c1 += 1
    # _rules = get_data().get_tile_rules(0)
    # print(_rules)

## This method sets up the invalid combo tab.
func setup() -> void:
    _tile = 0 # Setting the starting tile to the first tile
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
        _invalid_list.add_item
        (
            "Self Rot: " + str(_element_ic.get_self_rot()) + ", " +
            "Edge: " + str(_element_ic.get_edge()) + ", " +
            "Type: " + str(_element_ic.get_type()) + ", " +
            "Rot: " + str(_element_ic.get_rot())
        )
        _c1 += 1
    
## This method sets the rule items.
func _set_tile_rules() -> void:
    _ob_type.clear()
    _rules = get_data().get_tile_rules(_tile) # Getting the rules for the tile
    _c1 = 0
    while _c1 < _rules.size(): # Loop for setting rule items
        _ob_type.add_item("(" + str(_rules[_c1]) + ") " + get_data().get_tile_name(_rules[_c1]))
        _c1 += 1