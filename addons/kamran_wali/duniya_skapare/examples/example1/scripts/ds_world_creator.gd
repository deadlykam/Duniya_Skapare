extends Node

enum Status{NONE, GENERATOR_PROCESSING, START_WORLD_CREATION}

@export_category("World Creator")
@export var _tiles: Array[PackedScene]
@export var _generator: DS_BaseGen
@export var _tile_holder: Node3D
@export_group("Tile Properties")
@export var _tile_offset_x:= 0.0
@export var _tile_offset_y:= 0.0
@export var _tile_offset_z:= 0.0

var _tile: Node3D
var _status:= Status.GENERATOR_PROCESSING
var _c:= 0

func _process(delta) -> void:
	if !Engine.is_editor_hint(): # Checking if NOT in editor mode
		if _status == Status.GENERATOR_PROCESSING: # Checking if the generator is processing
			if !_generator.is_gen_process(): _status = Status.START_WORLD_CREATION # Generator processing done
		elif _status == Status.START_WORLD_CREATION:
			if _c < _generator.get_grid().get_tiles_size():
				_tile = _tiles[_get_tile(_c).get_tile_type()].instantiate()
				_tile.position.x = _tile_offset_x * _get_tile(_c).get_x() # Setting new tile's x pos
				_tile.position.y = _tile_offset_z * _get_tile(_c).get_z() # Setting new tile's y pos
				_tile.position.z = _tile_offset_y * _get_tile(_c).get_y() # Setting new tile's z pos
				_tile.quaternion = _get_tile(_c).get_tile_rotation_quat()
				_tile_holder.add_child(_tile)
				_tile = null
				_c += 1
			else: _status = Status.NONE
		elif _status == Status.NONE:
			if _generator.is_gen_process(): _status = Status.GENERATOR_PROCESSING

## This method gets the indexth tile.
func _get_tile(index:int) -> DS_Tile: return _generator.get_grid().get_tile(index)
