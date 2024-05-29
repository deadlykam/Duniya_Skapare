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

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray
	if _generator == null: warnings.append("Generator: Please assign a DS_BaseGen.")
	if _world_creator == null: warnings.append("World Creator: Please assign the ds_world_creator.")
	else: if !_world_creator.has_method("_is_world_creator"): warnings.append("World Creator: The given Node does NOT contain ds_world_creator script.")
	return warnings

func _process(delta) -> void:
	if !Engine.is_editor_hint():
		if !_generator.is_gen_process() and !_world_creator.is_gen_world():
			if Input.is_action_just_pressed("ui_up"): _generator.expand_grid(1) # Expanding north
			elif Input.is_action_just_pressed("ui_down"): _generator.expand_grid(4) # Expanding south
			elif Input.is_action_just_pressed("ui_right"): _generator.expand_grid(2) # Expanding west
			elif Input.is_action_just_pressed("ui_left"): _generator.expand_grid(5) # Expanding west
			elif Input.is_action_just_pressed("ui_end"): _generator.expand_grid(0) # Expanding west
