@tool
extends "res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_base.gd"

var _msg_save: Label

func _enter_tree() -> void:
    _msg_save = $Msg_Save

func _on_btn_save_pressed():
    get_data()._data_wfc_not.save()
    get_data()._data_wfc_names.save()
    get_data()._data_wfc_rules.save()
    _msg_save.visible = false

## This method shows the unsaved message.
func show_unsaved_message(msg:String) -> void:
    _msg_save.text = msg
    _msg_save.visible = true