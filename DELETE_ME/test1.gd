extends Node

@export var _generator: DS_BaseGen

var _free_tiles: Array[int]

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		_free_tiles = _generator.get_tile_free_edges(0)
		if !_free_tiles.is_empty():
			_generator.add_tile(0)
