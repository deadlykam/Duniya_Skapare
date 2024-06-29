extends Node

@export_category("World Creator")
@export var _tiles: Array[PackedScene]
@export var _generator: DS_BaseGen
@export var _tile_holder: Node3D
@export_group("Tile Properties")
@export var _tile_offset_x:= 0.0
@export var _tile_offset_y:= 0.0
@export var _tile_offset_z:= 0.0

var _tile: Node3D
var _c:= 0

## This method checks if the world is being generated.
func is_gen_world() -> bool: return _c < _generator.get_grid().get_tiles_size()

func _process(delta) -> void:
	if !Engine.is_editor_hint(): # Checking if NOT in editor mode
		if !_generator.is_gen_process():
			if is_gen_world(): # Loop instantiating new tiles
				if _get_tile(_c).get_tile_type() != -1:
					_tile = _tiles[_get_tile(_c).get_tile_type()].instantiate() # Instantiating new tile
					_tile.position.x = _tile_offset_x * _get_tile(_c).get_x() # Setting new tile's x pos
					_tile.position.y = _tile_offset_z * _get_tile(_c).get_z() # Setting new tile's y pos
					_tile.position.z = _tile_offset_y * _get_tile(_c).get_y() # Setting new tile's z pos
					_tile.quaternion = _get_tile(_c).get_tile_rotation_quat() # Setting new tile's rotation
					_tile_holder.add_child(_tile) # Adding the tile to the game world
					# print("Created Tile: (", _get_tile(_c).get_x(), ", ", _get_tile(_c).get_y(), ", ", _get_tile(_c).get_z(), "), Type: ", _get_tile(_c).get_tile_type(), ", Rot: ", _get_tile(_c).get_tile_rotation())
					_tile = null
				_c += 1

## This method gets the indexth tile.
func _get_tile(index:int) -> DS_Tile: return _generator.get_grid().get_tile(index)

## This method is ONLY used for duck typing check.
func _is_world_creator() -> bool: return true
