@tool
extends Node

@export_category("Create Tile")
@export var _generator: DS_BaseGen:
	set(generator):
		if _generator != generator:
			_generator = generator
			update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	if _generator == null: warnings.append("Generator: Please assigne a DS_BaseGen.")
	return warnings

func _process(delta) -> void:
	if !Engine.is_editor_hint():
		if Input.is_action_just_pressed("ui_up"): _generator.expand_grid(1) # Expanding north
		elif Input.is_action_just_pressed("ui_down"): _generator.expand_grid(4) # Expanding north
		elif Input.is_action_just_pressed("ui_left"): _generator.expand_grid(2) # Expanding north