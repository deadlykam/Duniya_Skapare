extends Node

@export var _grid_control: Node
@export var _tile_control: Node

var _toggle:= true

func _ready() -> void:
	_grid_control.set_enabled(_toggle)
	_tile_control.set_enabled(!_toggle)

func _process(delta):
	if Input.is_action_just_released("ui_page_down"):
		_toggle = !_toggle
		_grid_control.set_enabled(_toggle)
		_tile_control.set_enabled(!_toggle)
