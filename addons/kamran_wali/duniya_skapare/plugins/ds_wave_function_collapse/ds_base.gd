@tool
extends Control

const DS_WAVE_FUNCTION_COLLAPSE_UI = preload("res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_wave_function_collapse_ui.gd")

var _main_ui: DS_WAVE_FUNCTION_COLLAPSE_UI

## This method gets the instance of DS_Data.
func get_data() -> DS_Data:
    return _main_ui.get_data()
    # return DS_Data.get_instance()

func set_main_ui(main_ui: DS_WAVE_FUNCTION_COLLAPSE_UI) -> void:
    _main_ui = main_ui

## This method gets the main UI script.
func get_main_ui() -> DS_WAVE_FUNCTION_COLLAPSE_UI:
    return _main_ui