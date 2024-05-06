@tool
extends "res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_base.gd"

# Properties from the scene
var _ob_tile_list: OptionButton

# Properties for internal usage
var _counter:= -1

func _enter_tree() -> void:
    _ob_tile_list = $Holder/Tile_Selection_Container/OB_Tile_List

func setup() -> void:
    _ob_tile_list.clear()
    _counter = 0

    # Loop to update the option list with the tile names
    while _counter < get_data().get_wfc_number_of_tiles():
        _ob_tile_list.add_item(get_data()._data_wfc_names.get_element(_counter))
        _counter += 1