extends Node

var _grid_wfc: DS_GridWFC
var _counter:= -1
var _blocks: Array[int]
var _msg: String

func _ready() -> void:
	_grid_wfc = DS_GridWFC.new()
	print_blocks(0)
	print_blocks(1)
	print_blocks(2)

func print_blocks(index: int) -> void:
	_blocks = _grid_wfc._get_all_block_types(index)
	_msg = "Block " + str(index) + "-> "
	_counter = 0

	while _counter < _blocks.size():
		_msg = _msg + str(_blocks[_counter]) + " "
		_counter += 1
	
	print(_msg)
