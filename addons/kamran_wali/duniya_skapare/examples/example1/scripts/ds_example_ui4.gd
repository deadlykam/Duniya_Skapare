extends Node

@export var _generator: DS_BaseGen
@export var _stage_progress_bar: ProgressBar
@export var _control_container: Control

func _process(delta) -> void:
	_stage_progress_bar.set_value_no_signal(_generator.get_percentage_loaded_normal() * 100)

func _on_cb_control_toggled(button_pressed:bool): _control_container.visible = button_pressed