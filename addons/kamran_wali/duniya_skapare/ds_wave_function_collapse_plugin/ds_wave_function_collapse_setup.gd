@tool
class_name DS_WFCSetup
extends "res://addons/kamran_wali/duniya_skapare/ds_wave_function_collapse_plugin/ds_base_ui_setup.gd"

# Constants
const NAME_INPUT: GDScript = preload("res://addons/kamran_wali/duniya_skapare/ds_wave_function_collapse_plugin/ds_name_input.gd")
const CARDINAL_RULE_UI_SETUP: GDScript = preload("res://addons/kamran_wali/duniya_skapare/ds_wave_function_collapse_plugin/ds_cardinal_rule_ui_setup.gd")

# Properties from the scene
var _obtn_noo: OptionButton
var _name_input_container: Control
var _name_horizontal_container: Control
var _list_verticals_container: Control
var _lbl_save_msg: Label
var _tile_rule_cardinal_container: Control
var _ob_selected_tile: OptionButton

# Properties for internal usage
var _noo := 0
var _name_inputs: Array[NAME_INPUT]
var _h_names: Array[Label]
var _v_data: Array[Control]
var _cardinal_uis: Array[CARDINAL_RULE_UI_SETUP]
var _counter:= -1
var _counter2:= -1
var _obj_size:= -1
var _is_setup_done:= false

func _enter_tree() -> void:
    get_data()._data_wfc_rules_individual.check_data()
    _name_input_container = $MainTabContainer/MainSettings/MainScrollContainer/ScrollHolder/MainScrollContainer/NameInputContainer
    _obtn_noo = $MainTabContainer/MainSettings/MainScrollContainer/ScrollHolder/MainScrollContainer/NoOHolder/OB_NoO
    _name_horizontal_container = $MainTabContainer/MainSettings/MainScrollContainer/ScrollHolder/MainScrollContainer/ConditionHolder/ListVerticalsContainer/NameHorizontalContainer
    _list_verticals_container = $MainTabContainer/MainSettings/MainScrollContainer/ScrollHolder/MainScrollContainer/ConditionHolder/ListVerticalsContainer
    _lbl_save_msg = $MainTabContainer/MainSettings/SaveButtonContainer/Lbl_Save_Msg
    _tile_rule_cardinal_container = $MainTabContainer/TileRules/RulesScrollContainer/ObjectContainer/CardinalContainer
    _ob_selected_tile = $MainTabContainer/TileRules/RulesScrollContainer/ObjectContainer/SelectTileContainer/OB_SelectedTile

    
func _ready() -> void:
    _setup_obtn_noo()
    _setup_array_data()
    _setup_check_boxes()
    _setup_cardinal_uis()
    _show_inputs() # Making sure at the start correct inputs are shown
    _lbl_save_msg.text = "" # Making sure starting changes are NOT shown

## This method updates the name of the objects.
func update_name(name:String , id:int) -> void:
    _h_names[id].text = name
    _v_data[id].get_child(0).text = name
    get_data()._data_wfc_names.update_element(name, id)
    _set_lbl_save_msg("Unsaved Changes!")

## This method updates the check box toggle.
func update_check_box(id_main:int, id_pos:int, toggle:bool) -> void:
    get_data()._data_wfc_rules.update_element(id_main, id_pos, toggle)
    _set_lbl_save_msg("Unsaved Changes!")

## This method sets up the cardinal uis.
func _setup_cardinal_uis() -> void:
    _counter = 0
    # Loop for finding all the cardinal uis
    while _counter < _tile_rule_cardinal_container.get_child_count():
        # Condition to check if the child is a cardinal ui
        if _tile_rule_cardinal_container.get_child(_counter).has_method("_is_cardinal_rule_ui_setup"):
            _cardinal_uis.append(_tile_rule_cardinal_container.get_child(_counter))
        _counter += 1

## This method setups up the number of objects button option.
func _setup_obtn_noo() -> void:
    _obtn_noo.clear()
    _obtn_noo.add_item("1")
    _obtn_noo.add_item("2")
    _obtn_noo.add_item("3")
    _noo = get_data()._data_wfc_noo.get_value()
    _obtn_noo.select(_noo)

## This method sets up the check boxes.
func _setup_check_boxes() -> void:
    _counter = 1

    # Loop for setting up the check boxes
    while _counter < _list_verticals_container.get_child_count():
        _counter2 = 1
        while _counter2 < _list_verticals_container.get_child(_counter).get_child_count():
            _list_verticals_container.get_child(_counter).get_child(_counter2).setup(self,
                _counter - 1, _counter2 - 1, get_data()._data_wfc_rules.get_element(_counter - 1, _counter2 - 1))
            _counter2 += 1
        _counter += 1

## This method gets all the name input data and stores it the array.
func _setup_array_data() -> void:
    _obj_size = _name_input_container.get_child_count()
    _counter = 0

    # Loop for adding all the name input children
    while _counter < _obj_size:
        _name_inputs.append(_name_input_container.get_child(_counter))
        _name_inputs[_counter].set_manager(self)
        _name_inputs[_counter].set_id(_counter)
        _name_inputs[_counter].set_label_id()
        _h_names.append(_name_horizontal_container.get_child(_counter))
        _v_data.append(_list_verticals_container.get_child(_counter + 1))
        
        _name_inputs[_counter].set_txt_name(get_data()._data_wfc_names.get_element(_counter))
        _h_names[_counter].text = get_data()._data_wfc_names.get_element(_counter)
        _v_data[_counter].get_child(0).text = get_data()._data_wfc_names.get_element(_counter)
        
        _counter += 1

func _on_ob_no_o_item_selected(index:int):
    if _noo != index: # Checking if a new selection is made
        #TODO: Make the individual tile rules to default after one
        _noo = index
        get_data()._data_wfc_noo.set_value(_noo) # Setting the number of objects value in the data
        _show_inputs() # Showing the correct inputs
        _set_lbl_save_msg("Unsaved Changes!")

func _on_btn_save_pressed():
    get_data()._data_wfc_names.save()
    get_data()._data_wfc_rules.save()
    get_data()._data_wfc_noo.save()
    get_data()._data_wfc_rules_individual.save()
    _lbl_save_msg.text = ""

func _on_btn_reset_pressed():
    _counter = 0
    while _counter < get_data()._data_wfc_names.get_size(): # Loop for resetting the names
        get_data()._data_wfc_names._data[_counter] = str(_counter)
        _counter += 1
    
    get_data()._data_wfc_noo.set_value(0) # Resetting number of objects
    
    _counter = 0
    while _counter < get_data()._data_wfc_rules._data.size(): # Loop for resetting the rules
        get_data()._data_wfc_rules._data[_counter] = false
        _counter += 1
    
    # Resetting all the cardinal individual rules
    get_data()._data_wfc_rules_individual._north.clear()
    get_data()._data_wfc_rules_individual._east.clear()
    get_data()._data_wfc_rules_individual._south.clear()
    get_data()._data_wfc_rules_individual._west.clear()

    _counter = 0
    while _counter < get_data()._data_wfc_rules_individual._north_size.size(): # Loop for resetting the size and pos
        get_data()._data_wfc_rules_individual._north_size[_counter] = -1
        get_data()._data_wfc_rules_individual._east_size[_counter] = -1
        get_data()._data_wfc_rules_individual._south_size[_counter] = -1
        get_data()._data_wfc_rules_individual._west_size[_counter] = -1
        get_data()._data_wfc_rules_individual._north_pos[_counter] = 0
        get_data()._data_wfc_rules_individual._east_pos[_counter] = 0
        get_data()._data_wfc_rules_individual._south_pos[_counter] = 0
        get_data()._data_wfc_rules_individual._west_pos[_counter] = 0
        _counter += 1
    
    _show_inputs()
    _setup_check_boxes()

func _on_main_tab_container_tab_changed(tab:int):
    if tab == 1: # Condition for updating the Tile Rules tab
        _counter = 0
        _ob_selected_tile.clear()

        # Loop for adding names to the selected list
        while _counter < get_data()._data_wfc_noo.get_value() + 1:
            _ob_selected_tile.add_item(get_data()._data_wfc_names.get_element(_counter))
            _counter += 1
        
        # Showing rules for already selected tile
        _show_default_individual_rules(_ob_selected_tile.selected)

func _on_ob_selected_tile_item_selected(index:int):
    _show_default_individual_rules(index)

## This method shows the rules for the selected tile.
func _show_default_individual_rules(tile:int) -> void:
    _counter = 0
    
    # Loop for setting all the cardinal UIs
    while _counter < _cardinal_uis.size():
        _cardinal_uis[_counter].setup(tile)
        _counter += 1
    pass

## This method shows the correct inputs.
func _show_inputs() -> void:
    _counter = 0

    # Loop for showing the correct inputs
    while _counter < _obj_size:
        if _counter <= _noo: # Condition for showing the inputs
            if !_name_inputs[_counter].visible:
                _name_inputs[_counter].show()
                _h_names[_counter].show()
                _v_data[_counter].show()
        else: # Condition for hiding the inputs
            if _name_inputs[_counter].visible:
                _name_inputs[_counter].hide()
                _h_names[_counter].hide()
                _v_data[_counter].hide()
        _counter += 1

## This method sets the message for the save label.
func _set_lbl_save_msg(msg:String) -> void:
    _lbl_save_msg.text = msg