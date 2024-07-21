extends Control

@export var _control_1: Node
@export var _generator: DS_BaseGen
@export var _stage_progress_bar: ProgressBar
@export var _lbl_current_mode: Label
@export var _control_container: Control
@export var _lbl_expander_controls: Label
@export var _lbl_tile_controls: Label

func _process(delta) -> void:
	_stage_progress_bar.set_value_no_signal(_generator.get_percentage_loaded_normal() * 100)

	if _control_1.is_expander_control():
		_lbl_current_mode.text = "Current Mode: Expand Grid"
		_lbl_expander_controls.visible = true
		_lbl_tile_controls.visible = false
	else:
		_lbl_current_mode.text = "Current Mode: Tile Checker"
		_lbl_expander_controls.visible = false
		_lbl_tile_controls.visible = true

func _on_cb_control_toggled(button_pressed:bool): _control_container.visible = button_pressed
