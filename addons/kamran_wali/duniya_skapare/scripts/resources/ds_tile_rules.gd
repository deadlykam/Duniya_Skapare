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
var _counter_pos:= -1

## This method checks if the data are correct. If not then it will correc them
func check_data() -> void:
    #TODO: New size element must have a value of -1 that will be used by other scripts <-- !***
    # Condition to check if the data are NOT correct and to correct them
    if _north_pos.size() != DS_Data.get_instance().get_wfc_max_tiles():
        _north_pos.resize(DS_Data.get_instance().get_wfc_max_tiles())
        _east_pos.resize(DS_Data.get_instance().get_wfc_max_tiles())
        _south_pos.resize(DS_Data.get_instance().get_wfc_max_tiles())
        _west_pos.resize(DS_Data.get_instance().get_wfc_max_tiles())
        _north_size.resize(DS_Data.get_instance().get_wfc_max_tiles())
        _east_size.resize(DS_Data.get_instance().get_wfc_max_tiles())
        _south_size.resize(DS_Data.get_instance().get_wfc_max_tiles())
        _west_size.resize(DS_Data.get_instance().get_wfc_max_tiles())

## This method adds a rule to the north tile.
func add_north_rule(index:int, tile:int) -> void:
    add_cardinal_rule(index, tile, 0)

## This method removes a rule from the north tile.
func remove_north_rule(index:int, tile:int) -> void:
    remove_cardinal_rule(index, tile, 0)

## This method gets all the north indexth's data. It is recommended to store
## the return value and then use it. Calling this method multiple times
## will result in negative performance.
func get_north_rules(index:int) -> Array[int]:
    return get_cardinal_rules(index, 0)

## This method gets the indexth north size.
func get_north_size(index:int) -> int:
    return get_cardinal_size(index, 0)

## This method adds a rule to the east tile.
func add_east_rule(index:int, tile:int) -> void:
    add_cardinal_rule(index, tile, 1)

## This method removes a rule from the east tile.
func remove_east_rule(index:int, tile:int) -> void:
    remove_cardinal_rule(index, tile, 1)

## This method gets all the east indexth's data. It is recommended to store
## the return value and then use it. Calling this method multiple times
## will result in negative performance.
func get_east_rules(index:int) -> Array[int]:
    return get_cardinal_rules(index, 1)

## This method gets the indexth east size.
func get_east_size(index:int) -> int:
    return get_cardinal_size(index, 1)

## This method adds a rule to the south tile.
func add_south_rule(index:int, tile:int) -> void:
    add_cardinal_rule(index, tile, 2)

## This method removes a rule from the south tile.
func remove_south_rule(index:int, tile:int) -> void:
    remove_cardinal_rule(index, tile, 2)

## This method gets all the south indexth's data. It is recommended to store
## the return value and then use it. Calling this method multiple times
## will result in negative performance.
func get_south_rules(index:int) -> Array[int]:
    return get_cardinal_rules(index, 2)

## This method gets the indexth south size.
func get_south_size(index:int) -> int:
    return get_cardinal_size(index, 2)

## This method adds a rule to the west tile.
func add_west_rule(index:int, tile:int) -> void:
    add_cardinal_rule(index, tile, 3)

## This method removes a rule from the west tile.
func remove_west_rule(index:int, tile:int) -> void:
    remove_cardinal_rule(index, tile, 3)

## This method gets all the west indexth's data. It is recommended to store
## the return value and then use it. Calling this method multiple times
## will result in negative performance.
func get_west_rules(index:int) -> Array[int]:
    return get_cardinal_rules(index, 3)

## This method gets the indexth west size.
func get_west_size(index:int) -> int:
    return get_cardinal_size(index, 3)

## This method adds rules to the given cardinals.
## North = 0
## East = 1
## South = 2
## West = 3
func add_cardinal_rule(index:int, tile:int, cardinal:int) -> void:
    if cardinal == 0: # North
        if _north_size[index] == -1: # Checking if first insertion of index
            _north_size[index] = 0 # Making size 0 for first insertion for correct calculations
        
        _north.insert(_north_pos[index], tile)
        _update_size_pos(index, 1, 0)
    elif cardinal == 1: # East
        if _east_size[index] == -1: # Checking if first insertion of index
            _east_size[index] = 0 # Making size 0 for first insertion for correct calculations
        
        _east.insert(_east_pos[index], tile)
        _update_size_pos(index, 1, 1)
    elif cardinal == 2: # South
        if _south_size[index] == -1: # Checking if first insertion of index
            _south_size[index] = 0 # Making size 0 for first insertion for correct calculations
        
        _south.insert(_south_pos[index], tile)
        _update_size_pos(index, 1, 2)
    elif cardinal == 3: # West
        if _west_size[index] == -1: # Checking if first insertion of index
            _west_size[index] = 0 # Making size 0 for first insertion for correct calculations
        
        _west.insert(_west_pos[index], tile)
        _update_size_pos(index, 1, 3)

## This method removes a rules from the given cardianl.
## North = 0
## East = 1
## South = 2
## West = 3
func remove_cardinal_rule(index:int, tile:int, cardinal:int) -> void:
    if cardinal == 0: # North
        if _north_size[index] > 0: # Checking if north has at least 1 element
            _counter1 = 0
            while _counter1 < _north_size[index]: # Loop for finding the element to remove
                if tile == _north[_north_pos[index] + _counter1]: # Element found to remove
                    _north.remove_at(_north_pos[index] + _counter1)
                    _update_size_pos(index, -1, 0)
                    break
                _counter1 += 1
    elif cardinal == 1: # East
        if _east_size[index] > 0: # Checking if north has at least 1 element
            _counter1 = 0
            while _counter1 < _east_size[index]: # Loop for finding the element to remove
                if tile == _east[_east_pos[index] + _counter1]: # Element found to remove
                    _east.remove_at(_east_pos[index] + _counter1)
                    _update_size_pos(index, -1, 1)
                    break
                _counter1 += 1
    elif cardinal == 2: # South
        if _south_size[index] > 0: # Checking if north has at least 1 element
            _counter1 = 0
            while _counter1 < _south_size[index]: # Loop for finding the element to remove
                if tile == _south[_south_pos[index] + _counter1]: # Element found to remove
                    _south.remove_at(_south_pos[index] + _counter1)
                    _update_size_pos(index, -1, 2)
                    break
                _counter1 += 1
    elif cardinal == 3: # West
        if _west_size[index] > 0: # Checking if north has at least 1 element
            _counter1 = 0
            while _counter1 < _west_size[index]: # Loop for finding the element to remove
                if tile == _west[_west_pos[index] + _counter1]: # Element found to remove
                    _west.remove_at(_west_pos[index] + _counter1)
                    _update_size_pos(index, -1, 3)
                    break
                _counter1 += 1

## This method gets all rules for the indexth cardinal.
## North = 0
## East = 1
## South = 2
## West = 3
func get_cardinal_rules(index:int, cardinal:int) -> Array[int]:
    _temp_data.clear()
    _counter1 = 0

    if cardinal == 0: # North
        while _counter1 < _north_size[index]: # Loop for adding all the elements
            _temp_data.append(_north[_north_pos[index] + _counter1])
            _counter1 += 1
    elif cardinal == 1: # East
        while _counter1 < _east_size[index]: # Loop for adding all the elements
            _temp_data.append(_east[_east_pos[index] + _counter1])
            _counter1 += 1
    elif cardinal == 2: # South
        while _counter1 < _south_size[index]: # Loop for adding all the elements
            _temp_data.append(_south[_south_pos[index] + _counter1])
            _counter1 += 1
    elif cardinal == 3: # West
        while _counter1 < _west_size[index]: # Loop for adding all the elements
            _temp_data.append(_west[_west_pos[index] + _counter1])
            _counter1 += 1

    return _temp_data

## This method gets the size for the indexth cardinal.
## North = 0
## East = 1
## South = 2
## West = 3
func get_cardinal_size(index:int, cardinal:int) -> int:
    return (_north_size[index] if cardinal == 0 else _east_size[index] if cardinal == 1 else
            _south_size[index] if cardinal == 2 else _west_size[index] if cardinal == 3 else -1)

## This method updates the size and pos of a cardinal.
## North = 0
## East = 1
## South = 2
## West = 3
func _update_size_pos(index:int, dir:int, cardinal:int) -> void:
    if cardinal == 0: # North
        _north_size[index] += dir # Updating size
        _counter_pos = index + 1
        while _counter_pos < _north_pos.size(): # Loop for updating pos
            _north_pos[_counter_pos] = 0 if (_north_pos[_counter_pos] + dir) <= 0 else _north_pos[_counter_pos] + dir
            _counter_pos += 1
    elif cardinal == 1: # East
        _east_size[index] += dir # Updating size
        _counter_pos = index + 1
        while _counter_pos < _east_pos.size(): # Loop for updating pos
            _east_pos[_counter_pos] = 0 if (_east_pos[_counter_pos] + dir) <= 0 else _east_pos[_counter_pos] + dir
            _counter_pos += 1
    elif cardinal == 2: # South
        _south_size[index] += dir # Updating size
        _counter_pos = index + 1
        while _counter_pos < _south_pos.size(): # Loop for updating pos
            _south_pos[_counter_pos] = 0 if (_south_pos[_counter_pos] + dir) <= 0 else _south_pos[_counter_pos] + dir
            _counter_pos += 1
    elif cardinal == 3: # West
        _west_size[index] += dir # Updating size
        _counter_pos = index + 1
        while _counter_pos < _west_pos.size(): # Loop for updating pos
            _west_pos[_counter_pos] = 0 if (_west_pos[_counter_pos] + dir) <= 0 else _west_pos[_counter_pos] + dir
            _counter_pos += 1