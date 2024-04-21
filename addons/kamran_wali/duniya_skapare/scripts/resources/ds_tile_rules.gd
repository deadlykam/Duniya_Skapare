@tool
extends "res://addons/kamran_wali/duniya_skapare/scripts/resources/ds_base_resource.gd"

@export var _north: Array[int]
@export var _east: Array[int]
@export var _south: Array[int]
@export var _west: Array[int]
@export var _north_pos: Array[int]
@export var _east_pos: Array[int]
@export var _south_pos: Array[int]
@export var _west_pos: Array[int]
@export var _north_size: Array[int]
@export var _east_size: Array[int]
@export var _south_size: Array[int]
@export var _west_size: Array[int]

var _temp_data: Array[int]
var _counter1:= -1
var _counter2:= -1

## This method checks if the data are correct. If not then it will correc them
func check_data() -> void:
    #TODO: New size element must have a value of -1 that will be used by other scripts
    # Condition to check if the data are NOT correct and to correct them
    if _north_pos.size() != DS_Data.get_instance()._data_wfc_names.get_size():
        _north_pos.resize(DS_Data.get_instance()._data_wfc_names.get_size())
        _east_pos.resize(DS_Data.get_instance()._data_wfc_names.get_size())
        _south_pos.resize(DS_Data.get_instance()._data_wfc_names.get_size())
        _west_pos.resize(DS_Data.get_instance()._data_wfc_names.get_size())
        _north_size.resize(DS_Data.get_instance()._data_wfc_names.get_size())
        _east_size.resize(DS_Data.get_instance()._data_wfc_names.get_size())
        _south_size.resize(DS_Data.get_instance()._data_wfc_names.get_size())
        _west_size.resize(DS_Data.get_instance()._data_wfc_names.get_size())

## This method adds a north tile.
func add_north_rule(index:int, tile:int) -> void:
    if _north.size() == 0:
        _north.append(tile)
        _north_pos[index] = 0
        _north_size[index] = 1
    else:
        _north.insert(_north_pos[index], tile)
        _north_size[index] += 1
        _counter1 = index + 1
        while _counter1 < _north_pos.size():
            _north_pos[_counter1] += 1
            _counter1 += 1

func remove_north_rule(index:int, tile:int) -> void:
    if _north.size() > 0: # Checking if north has at least 1 element
        _counter1 = 0
        while _counter1 < _north_size[index]: # Loop for finding the element to remove
            if tile == _north[_north_pos[index] + _counter1]: # Element found to remove
                _north.remove_at(_north_pos[index] + _counter1)
                _north_size[index] -= 1 # Decreasing the size
                _counter2 = index + 1
                while _counter2 < _north_pos.size(): # Loop for shifting all the pos
                    _north_pos[_counter2] -= 1
                    _counter2 += 1
                break
            _counter1 += 1

## This method gets all the north indexth's data. It is recommended to store
## the return value and then use it. Calling this method multiple times
## will result in negative performance.
func get_north_rules(index:int) -> Array[int]:
    _temp_data.clear()
    _counter1 = 0
    while _counter1 < _north_size[index]: # Loop for adding all the elements
        _temp_data.append(_north[_north_pos[index] + _counter1])
        _counter1 += 1
    return _temp_data

## This method gets the indexth north size.
func get_north_size(index:int) -> int:
    return _north_size[index]

# TODO: Make the size change and pos shifts into a method. <- !