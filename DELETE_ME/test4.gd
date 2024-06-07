extends Node

@export var _camera_control: Node
@export var _tile_control: Node

var _toggle:= true

func _ready() -> void:
	_camera_control.set_enabled(_toggle)
	_tile_control.set_enabled(!_toggle)

func _process(delta):
	if Input.is_action_just_released("ui_page_down"):
		_toggle = !_toggle
		_camera_control.set_enabled(_toggle)
		_tile_control.set_enabled(!_toggle)
