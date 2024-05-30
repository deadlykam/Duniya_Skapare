extends Node3D

const _SPEED_OFFSET = 1.0

var _speed:= 1.0
var _is_enabled = true

## This method enables/disables the script.
func set_enabled(is_enable:bool) -> void: _is_enabled = is_enable

func _ready() -> void: _is_enabled = true

func _process(delta) -> void:
    if _is_enabled: # Condition to allow camera movement
        if Input.is_action_pressed("ui_up"): translate(Vector3.MODEL_FRONT * _speed * -1 * delta)
        elif Input.is_action_pressed("ui_down"): translate(Vector3.MODEL_FRONT * _speed * delta)
        elif Input.is_action_pressed("ui_left"): translate(Vector3.MODEL_LEFT * _speed * -1 * delta)
        elif Input.is_action_pressed("ui_right"): translate(Vector3.MODEL_RIGHT * _speed * -1 * delta)
        elif Input.is_action_pressed("ui_page_up"): translate(Vector3.MODEL_TOP * _speed * delta)
        elif Input.is_action_pressed("ui_page_down"): translate(Vector3.MODEL_BOTTOM * _speed * delta)

        if Input.is_action_just_released("ui_home"): _speed += _SPEED_OFFSET
        elif Input.is_action_just_released("ui_end"): 
            _speed = 1 if _speed - _SPEED_OFFSET <= 0 else _speed - _SPEED_OFFSET