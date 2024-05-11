@tool
extends "res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_base.gd"

# Constants
const DS_WFC_DATA: GDScript = preload("res://addons/kamran_wali/duniya_skapare/resources/ds_wfc_data.gd")
const DS_STRING_VAR: GDScript = preload("res://addons/kamran_wali/duniya_skapare/resources/ds_string_var.gd")

# Properties from the scene
var _lbl_menu_name: Label
var _txt_path: LineEdit
var _txt_name: LineEdit
var _name_container: Control
var _btn_action: Button

# Properties for internal usage
var _save_path: DS_STRING_VAR = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse/save_path.tres")
var _load_path: DS_STRING_VAR = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse/load_path.tres")
var _dir: DirAccess
var _is_save:= false
var _variable

func _enter_tree() -> void:
    _lbl_menu_name = $HeaderPanel/Lbl_Menu_Name
    _txt_path = $PathContainer/Txt_Path
    _txt_name = $NameContainer/Txt_Name
    _name_container = $NameContainer
    _btn_action = $ButtonContainer/Btn_Action

func show_menu(is_save:bool) -> void:
    _is_save = is_save
    _txt_name.text = ""
    _lbl_menu_name.text = ("SAVE" if _is_save else "LOAD") + " DATA"
    _txt_path.text = _save_path.get_value() if is_save else _load_path.get_value()
    _name_container.visible = _is_save
    _btn_action.text = "SAVE" if _is_save else "LOAD"
    visible = true

func _on_btn_cancel_pressed():
    visible =  false

func _on_btn_action_pressed():
    print(("Save Action" if _is_save else "Load Action"))
    _dir = DirAccess.open(_save_path.get_value() if _is_save else _load_path.get_value())

    if _dir != null: # Checking if dir NOT null
        if _is_save: # Checking if the mode is save mode
            _dir.make_dir(_save_path.get_value() + "/" + _txt_name.text) # Creating the folder
            _create_resources()

    if _is_save: _save_path.save() # Saving the path
    else: _load_path.save() # Savin the path
    
    # if _is_save:
    #     _dir.open(_save_path.get_value())
    #     if 

func _on_txt_path_text_changed(new_text:String):
    if _is_save:
        _save_path.set_value(new_text)
    else:
        _load_path.set_value(new_text)

## This method creates the resources and sets them to the correct data.
func _create_resources() -> void:
    # TODO: Create the NoT resource, update value to 1, store to self ref and save it.
    # TODO: Create the names resource, update it to have 1 element with the default name "Tile" in it.
    # TODO: Create the rules resource, update it to having only 1 element in it without any rules.
    # _variable = DS_INT_VAR.new()
    _variable.set_value(1)
    print(ResourceSaver.save(_variable, _save_path.get_value() + "/" + _txt_name.text + "/" + _txt_name.text + "_NoT.tres", 0))

    # TODO: Send the variable to be stored in the wfc data