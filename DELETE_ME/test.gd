extends Node

@export var _wfc: DS_WFCGen
@export var _counter:= 1

var _c_success:= 0
var _c_fail:= 0
var _is_show_result:= false

# func _ready():
# 	print(_wfc)

func _process(delta) -> void:
	if _counter >= 0:
		if !_wfc.is_processing():
			if _wfc.is_gen_success(): _c_success += 1
			else: _c_fail += 1
			_wfc.reset()
			_wfc.setup()
			_counter -= 1
	else:
		if !_is_show_result:
			print("===Result===")
			print_rich("[color=green]Success: ", _c_success,"[/color], [color=red]Fail:: ", _c_fail,"[/color]")
			_is_show_result = true
