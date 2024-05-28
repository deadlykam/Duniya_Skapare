@tool
extends Node

@export_category("Create Tile")
@export var _generator: DS_BaseGen:
	set(generator):
		if _generator != generator:
			_generator = generator
			update_configuration_warnings()

@export var _highlighter: Node3D:
	set(highlighter):
		if _highlighter != highlighter:
			_highlighter = highlighter
			update_configuration_warnings()
	
@export var _offset_x:= 0.0
@export var _offset_y:= 0.0
@export var _offset_z:= 0.0

var _tile: DS_Tile
var _x:= 0
var _y:= 0
var _z:= 0

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	
	if _generator == null: warnings.append("Generator: Please assigne a DS_BaseGen.")
	if _highlighter == null: warnings.append("Highlighter: Please provide a highlighter model.")

	return warnings

func _process(delta) -> void:
	if !Engine.is_editor_hint():
		if Input.is_action_just_pressed("ui_up"):
			if _generator.get_grid().has_tile_coord_x_y_z(_x, _y - 1, _z):
				_y -= 1
				_set_highlighter_pos()
		elif Input.is_action_just_pressed("ui_down"):
			if _generator.get_grid().has_tile_coord_x_y_z(_x, _y + 1, _z):
				_y += 1
				_set_highlighter_pos()
		elif Input.is_action_just_pressed("ui_left"):
			if _generator.get_grid().has_tile_coord_x_y_z(_x - 1, _y, _z):
				_x -= 1
				_set_highlighter_pos()
		elif Input.is_action_just_pressed("ui_right"):
			if _generator.get_grid().has_tile_coord_x_y_z(_x + 1, _y, _z):
				_x += 1
				_set_highlighter_pos()
		elif Input.is_action_just_pressed("ui_end"):
			_generator.add_tile(_generator.get_grid().get_tile_coord_x_y_z(_x, _y, _z))
		elif Input.is_action_just_pressed("ui_home"):
			_tile = _generator.get_grid().get_tile_coord_x_y_z(_x, _y, _z)
			print("Tile: ", _generator.get_tile_index(_tile))
			print("- Type: ", _tile.get_tile_type())
			print("- Rot: ", _tile.get_tile_rotation())

## This method sets the position of the highlighter.
func _set_highlighter_pos() -> void:
	_highlighter.position.x = _x * _offset_x
	_highlighter.position.y = _z * _offset_z
	_highlighter.position.z = _y * _offset_y