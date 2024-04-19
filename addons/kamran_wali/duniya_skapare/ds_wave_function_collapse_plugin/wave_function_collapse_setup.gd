@tool
class_name DS_WFCSetup
extends Control

# Constants
const NAME_INPUT: GDScript = preload("res://addons/kamran_wali/duniya_skapare/ds_wave_function_collapse_plugin/name_input.gd")

# Global Properties
var _data_names: DS_FixedStringArray
var _data_checkboxes: DS_FixedCheckBoxFlagArray
var _data_noo: DS_NoO

# Properties from the scene
var _obtn_noo: OptionButton
var _name_input_container: Control
var _name_horizontal_container: Control
var _list_verticals_container: Control
var _lbl_save_msg: Label

# Properties for internal usage
var _noo := 0
var _name_inputs: Array[NAME_INPUT]
var _h_names: Array[Label]
var _v_data: Array[Control]
var _counter:= -1
var _counter2:= -1
var _obj_size:= -1
var _is_setup_done:= false

func _enter_tree() -> void:
    _data_names = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse_settings/data_names.tres")
    _data_checkboxes = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse_settings/data_checkboxes.tres")
    _data_noo = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse_settings/data_noo.tres")
    _name_input_container = $MainTabContainer/MainSettings/MainScrollContainer/ScrollHolder/MainScrollContainer/NameInputContainer
    _obtn_noo = $MainTabContainer/MainSettings/MainScrollContainer/ScrollHolder/MainScrollContainer/NoOHolder/OB_NoO
    _name_horizontal_container = $MainTabContainer/MainSettings/MainScrollContainer/ScrollHolder/MainScrollContainer/ConditionHolder/ListVerticalsContainer/NameHorizontalContainer
    _list_verticals_container = $MainTabContainer/MainSettings/MainScrollContainer/ScrollHolder/MainScrollContainer/ConditionHolder/ListVerticalsContainer
    _lbl_save_msg = $MainTabContainer/MainSettings/SaveButtonContainer/Lbl_Save_Msg

func _ready() -> void:
    _setup_obtn_noo()
    _setup_array_data()
    _setup_check_boxes()
    _show_inputs() # Making sure at the start correct inputs are shown
    _lbl_save_msg.text = "" # Making sure starting changes are NOT shown

## This method updates the name of the objects.
func update_name(name:String , id:int) -> void:
    _h_names[id].text = name
    _v_data[id].get_child(0).text = name
    _data_names.update_element(name, id)
    _set_lbl_save_msg("Unsaved Changes!")

## This method updates the check box toggle.
func update_check_box(id_main:int, id_pos:int, toggle:bool) -> void:
    _data_checkboxes.update_element(id_main, id_pos, toggle)
    _set_lbl_save_msg("Unsaved Changes!")

## This method setups up the number of objects button option.
func _setup_obtn_noo() -> void:
    _obtn_noo.clear()
    _obtn_noo.add_item("1")
    _obtn_noo.add_item("2")
    _obtn_noo.add_item("3")
    _noo = _data_noo.get_value()
    _obtn_noo.select(_noo)

## This method sets up the check boxes.
func _setup_check_boxes() -> void:
    _counter = 1

    # Loop for setting up the check boxes
    while _counter < _list_verticals_container.get_child_count():
        _counter2 = 1
        while _counter2 < _list_verticals_container.get_child(_counter).get_child_count():
            _list_verticals_container.get_child(_counter).get_child(_counter2).setup(self, 
                _counter - 1, _counter2 - 1, _data_checkboxes.get_element(_counter - 1, _counter2 - 1))
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
        
        # Updating the names from the save file
        _name_inputs[_counter].set_txt_name(_data_names.get_element(_counter))
        _h_names[_counter].text = _data_names.get_element(_counter)
        _v_data[_counter].get_child(0).text = _data_names.get_element(_counter)

        _counter += 1

func _on_ob_no_o_item_selected(index:int):
    if _noo != index: # Checking if a new selection is made
        _noo = index
        _data_noo.set_value(_noo) # Setting the number of objects value in the data
        _show_inputs() # Showing the correct inputs
        _set_lbl_save_msg("Unsaved Changes!")

func _on_btn_save_pressed():
    _data_names.save()
    _data_checkboxes.save()
    _data_noo.save()
    _lbl_save_msg.text = ""

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