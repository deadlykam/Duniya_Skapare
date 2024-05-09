@tool
extends "res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_base.gd"

# Properties from the scene
var _lbl_menu_name: Label
var _txt_path: LineEdit
var _txt_name: LineEdit
var _name_container: Control
var _btn_action: Button

# Properties for internal usage
var _is_save:= false

func _enter_tree() -> void:
    _lbl_menu_name = $HeaderPanel/Lbl_Menu_Name
    _txt_path = $PathContainer/Txt_Path
    _txt_name = $NameContainer/Txt_Name
    _name_container = $NameContainer
    _btn_action = $ButtonContainer/Btn_Action

func show_menu(is_save:bool) -> void:
    _is_save = is_save
    _txt_path.text = ""
    _txt_name.text = ""
    _lbl_menu_name.text = ("SAVE" if _is_save else "LOAD") + " DATA"
    _name_container.visible = _is_save
    _btn_action.text = "SAVE" if _is_save else "LOAD"
    visible = true

func _on_btn_cancel_pressed():
    visible =  false

func _on_btn_action_pressed():
    print(("Save Action" if _is_save else "Load Action"))