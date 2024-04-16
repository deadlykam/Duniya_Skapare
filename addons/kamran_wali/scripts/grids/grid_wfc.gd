@tool
class_name DS_GridWFC

# Data Properties
var _data_names: DS_FixedStringArray
var _data_checkboxes: DS_FixedCheckBoxFlagArray
var _data_noo: DS_NoO

var _temp_blocks: Array[int]
var _counter1:= -1
var _counter2:= -1

func _init() -> void:
    _data_names = load("res://addons/kamran_wali/settings/data_names.tres")
    _data_checkboxes = load("res://addons/kamran_wali/settings/data_checkboxes.tres")
    _data_noo = load("res://addons/kamran_wali/settings/data_noo.tres")

## This method finds all the type of a block.
func _get_all_block_types(index:int) -> Array[int]:
    _temp_blocks.clear()
    _counter1 = 0 # The counter is the pos index

    # Loop for finding types
    while _counter1 <= index:
        # Condition for type found
        if _data_checkboxes.get_element(index, _counter1):
            _temp_blocks.append(_counter1) # Adding type
        _counter1 += 1
    
    # Setting the next main block for check.
    # Alos _counter1 is now the main index
    _counter1 = index + 1

    # Loop for finding types
    while _counter1 <= _data_noo.get_value():
        # Condition for type found
        if _data_checkboxes.get_element(_counter1, index):
            _temp_blocks.append(_counter1)
        _counter1 += 1
    
    return _temp_blocks