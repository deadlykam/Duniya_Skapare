@tool
extends "res://addons/kamran_wali/duniya_skapare/ds_wave_function_collapse_plugin/ds_base_ui_setup.gd"

@export_category("Cardinal Rule UI Setup")
@export var _cardinal_name: String
@export var _cardinal_index:= 0 # 0 = North, 1 = East, 2 = South, 3 = West

# Properties from the scene
var _lbl_cardinal_name: Label
var _item_names: ItemList

var _tile:= -1
var _rules: Array[int]
var _rules_indv: Array[int]
var _counter1:= -1
var _counter2:= -1
var _selected_items: PackedInt32Array
var _green: Color
var _red: Color
var _alpha:= 0.125
var _is_found_data:= false

func _enter_tree() -> void:
    _lbl_cardinal_name = $CardinalContainer/Lbl_CardinalName
    _item_names = $CardinalContainer/ItemContainer/Items_Names

    _lbl_cardinal_name.text = _cardinal_name
    _green = Color.GREEN
    _red = Color.RED

    _green.a = _alpha
    _red.a = _alpha

## This method sets the up UI with the given tile information.
func setup(tile:int) -> void:
    _tile = tile
    _item_names.clear()
    _rules = get_data().get_wfc_tile_rules(_tile)
    # TODO: If no rules found then hide the buttons.
    _validate_data()
    _setup_items()


func _on_btn_add_pressed():
    _selected_items = _item_names.get_selected_items()
    _counter1 = 0
    
    # Loop for adding individual rules
    while _counter1 < _selected_items.size():
        get_data()._data_wfc_rules_individual.add_north_rule(_tile, _rules[_selected_items[_counter1]])
        _set_item_colour(_selected_items[_counter1], _green)
        _counter1 += 1

func _on_btn_remove_pressed():
    _selected_items = _item_names.get_selected_items()
    _counter1 = 0
    
    # Loop for removing individual rules
    while _counter1 < _selected_items.size():
        get_data()._data_wfc_rules_individual.remove_north_rule(_tile, _rules[_selected_items[_counter1]])
        _set_item_colour(_selected_items[_counter1], _red)
        _counter1 += 1

## This method validates and corrects the data.
func _validate_data() -> void:
    if _cardinal_index == 0: # North
        _counter1 = 0
        _rules_indv = get_data()._data_wfc_rules_individual.get_north_rules(_tile)

        while _counter1 < _rules_indv.size(): # Loop for finding any extra element
            _is_found_data = false
            _counter2 = 0
            while _counter2 < _rules.size(): # Loop for checking extra element
                if _rules_indv[_counter1] == _rules[_counter2]: # Condition for extra element found
                    _is_found_data = true
                    break
                _counter2 += 1
            
            if !_is_found_data: # Condition for removing the extra element
                get_data()._data_wfc_rules_individual.remove_north_rule(_tile, _rules_indv[_counter1])

            _counter1 += 1
        
        _rules_indv.clear()
        get_data()._data_wfc_rules_individual.save()

## This method sets up the items.
func _setup_items() -> void:
    _counter1 = 0
    while _counter1 < _rules.size():
        _item_names.add_item(get_data().get_wfc_tile_name(_rules[_counter1]))
        _counter1 += 1

    if _cardinal_index == 0: # Checking if North
        # Condition for adding all the rules
        if (get_data()._data_wfc_rules_individual.get_north_size(_tile) == -1 &&
            _rules.size() > 0): 
            _counter1 = 0
            while _counter1 < _rules.size(): # Loop for adding all the rules
                get_data()._data_wfc_rules_individual.add_north_rule(_tile, _rules[_counter1])
                _counter1 += 1
            get_data()._data_wfc_rules_individual.save() # Saving when data are set here
        
        _rules_indv = get_data()._data_wfc_rules_individual.get_north_rules(_tile)
        _counter1 = 0
        while _counter1 < _rules.size(): # Loop for applying correct item colour
            _set_item_colour(_counter1, _red) # Making item red at first
            _counter2 = 0
            while _counter2 < _rules_indv.size(): # Loop for finding rules
                if _rules[_counter1] == _rules_indv[_counter2]:# Checking if rule found
                    _set_item_colour(_counter1, _green) # Making item green
                    break
                _counter2 += 1
            _counter1 += 1

## This method sets the colour of the indexth item.
func _set_item_colour(index:int, colour:Color) -> void:
    _item_names.set_item_custom_bg_color(index, colour)

## Duck typing checking only.
func _is_cardinal_rule_ui_setup() -> bool:
    return true