@tool
extends EditorPlugin

var _dock

func _enter_tree():
	_dock = preload("res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/wave_function_collapse_ui.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, _dock)


func _exit_tree():
	remove_control_from_docks(_dock)
	_dock.free()
