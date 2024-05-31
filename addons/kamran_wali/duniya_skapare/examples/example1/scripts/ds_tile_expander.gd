@tool
extends Node

@export_category("Create Tile")
@export var _generator: DS_BaseGen:
	set(generator):
		if _generator != generator:
			_generator = generator
			update_configuration_warnings()

@export var _world_creator: Node:
	set(world_creator):
		if _world_creator != world_creator:
			_world_creator = world_creator
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
var _is_enabled = true

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	if _generator == null: warnings.append("Generator: Please assigne a DS_BaseGen.")
	if _world_creator == null: warnings.append("World Creator: Please assign the ds_world_creator.")
	else: if !_world_creator.has_method("_is_world_creator"): warnings.append("World Creator: The given Node does NOT contain ds_world_creator script.")
	if _highlighter == null: warnings.append("Highlighter: Please provide a highlighter model.")
	return warnings

## This method enables/disables the script.
func set_enabled(is_enable:bool) -> void: _is_enabled = is_enable

func _ready() -> void: _is_enabled = true

func _process(delta) -> void:
	if !Engine.is_editor_hint():
		if !_generator.is_gen_process() and !_world_creator.is_gen_world() and _is_enabled:
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
				print(_tile)
				# print("Tile: ", _generator.get_tile_index(_tile))
				# print("- Type: ", _tile.get_tile_type())
				# print("- Rot: ", _tile.get_tile_rotation())
				# print("- Coord: (", _tile.get_x(), ", ", _tile.get_y(), ", ", _tile.get_z(), ")")

## This method sets the position of the highlighter.
func _set_highlighter_pos() -> void:
	_highlighter.position.x = _x * _offset_x
	_highlighter.position.y = _z * _offset_z
	_highlighter.position.z = _y * _offset_y
