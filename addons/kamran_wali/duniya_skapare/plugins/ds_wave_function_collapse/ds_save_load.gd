@tool
extends "res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_base.gd"

# Constants
const DS_WFC_DATA: GDScript = preload("res://addons/kamran_wali/duniya_skapare/resources/ds_wfc_data.gd")
const DS_STRING_VAR: GDScript = preload("res://addons/kamran_wali/duniya_skapare/resources/ds_string_var.gd")
const DS_WAVE_FUNCTION_COLLAPSE_UI = preload("res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_wave_function_collapse_ui.gd")

# Properties from the scene
var _lbl_menu_name: Label
var _txt_path: LineEdit
var _txt_name: LineEdit
var _name_container: Control
var _btn_action: Button

# Properties for internal usage
var _save_path: DS_STRING_VAR = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse/save_path.tres")
var _load_path: DS_STRING_VAR = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse/load_path.tres")
var _wave_function_collapse_ui: DS_WAVE_FUNCTION_COLLAPSE_UI
var _is_save:= false
var _dir: DirAccess
var _variable

func _enter_tree() -> void:
    _lbl_menu_name = $HeaderPanel/Lbl_Menu_Name
    _txt_path = $PathContainer/Txt_Path
    _txt_name = $NameContainer/Txt_Name
    _name_container = $NameContainer
    _btn_action = $ButtonContainer/Btn_Action

## This method initializes the edge rule ui.
func init(wave_function_collapse_ui:DS_WAVE_FUNCTION_COLLAPSE_UI) -> void:
    _wave_function_collapse_ui = wave_function_collapse_ui

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
    if _is_save: # Checking if the mode is save mode
        _create_wfc_data() # Creating wfc data
    else:
        _load_wfc_data() # Loading new data
        _wave_function_collapse_ui.load_setup()

    if _is_save: _save_path.save() # Saving the path
    else: _load_path.save() # Savin the path

func _on_txt_path_text_changed(new_text:String):
    if _is_save:
        _save_path.set_value(new_text)
    else:
        _load_path.set_value(new_text)

## This method loads the data.
func _load_wfc_data() -> void:
    get_data().set_wfc_data(load(_load_path.get_value()))


## This method creates the wave function collapse data.
func _create_wfc_data() -> void:
    _variable = DS_WFC_DATA.new()
    _variable.data_reset()
    ResourceSaver.save(_variable, _save_path.get_value() + "/" + _txt_name.text + ".tres", 0)