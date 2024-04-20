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

var _counter1:= -1

## This method checks if the data are correct. If not then it will correc them
func check_data() -> void:
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
func add_north(index:int, tile:int) -> void:
    _north.insert(_north_pos[index], tile)
    _north_size[index] += 1
    _counter1 = index + 1
    while _counter1 < _north_pos.size():
        _north_pos[_counter1] += 1