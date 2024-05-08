@tool
extends "res://addons/kamran_wali/duniya_skapare/resources/ds_base_resource.gd"

@export var _up_rules: Array[int]
@export var _north_rules: Array[int]
@export var _east_rules: Array[int]
@export var _bottom_rules: Array[int]
@export var _south_rules: Array[int]
@export var _west_rules: Array[int]
@export var _up_pos: Array[int]
@export var _north_pos: Array[int]
@export var _east_pos: Array[int]
@export var _bottom_pos: Array[int]
@export var _south_pos: Array[int]
@export var _west_pos: Array[int]
@export var _up_size: Array[int]
@export var _north_size: Array[int]
@export var _east_size: Array[int]
@export var _bottom_size: Array[int]
@export var _south_size: Array[int]
@export var _west_size: Array[int]

var _temp_data: Array[int]
var _tile:= -1
var _counter1:= -1
var _counter2:= -1
var _counter3:= -1
var _counter_pos:= -1

func data_resize(resize:int) -> void:
    if resize < _up_size.size(): # Condition to check if the resize requires to remove data
        while _up_size.size() > resize: # Loop to resize the arrays
            _tile = _up_size.size() - 1 # Tile to remove
            _counter2 = 0 # Acts as index for edges
            while _counter2 < 6: # Loop for going through all the edges
                while get_edge_size(_tile, _counter2) != 0: # Loop for removing all the edge rules
                    remove_edge_rule_at(_tile, 0, _counter2) # Removing the edge rules
                _counter2 += 1
            
            _counter2 = 0 # Acts as tiles
            while _counter2 < _up_size.size(): # Loop for going through all the tiles
                if _counter2 != _tile: # Condition to NOT remove from self
                    _counter3 = 0 # Acts as index of edges for the tiles
                    while _counter3 < 6: # Loop for removing the tile from all other tiles
                        remove_edge_rule_element(_counter2, _tile, _counter3) # Removing the tile
                        _counter3 += 1
                _counter2 += 1

            # Resizing sizes
            _up_size.remove_at(_up_size.size() - 1)
            _north_size.remove_at(_north_size.size() - 1)
            _east_size.remove_at(_east_size.size() - 1)
            _bottom_size.remove_at(_bottom_size.size() - 1)
            _south_size.remove_at(_south_size.size() - 1)
            _west_size.remove_at(_west_size.size() - 1)
            
            # Resizing positions
            _up_pos.remove_at(_up_pos.size() - 1)
            _north_pos.remove_at(_north_pos.size() - 1)
            _east_pos.remove_at(_east_pos.size() - 1)
            _bottom_pos.remove_at(_bottom_pos.size() - 1)
            _south_pos.remove_at(_south_pos.size() - 1)
            _west_pos.remove_at(_west_pos.size() - 1)
    elif resize > _up_size.size(): # Condition to increase the size
        # Resizing sizes
            _up_size.resize(resize)
            _north_size.resize(resize)
            _east_size.resize(resize)
            _bottom_size.resize(resize)
            _south_size.resize(resize)
            _west_size.resize(resize)
            
            # Resizing positions
            _up_pos.resize(resize)
            _north_pos.resize(resize)
            _east_pos.resize(resize)
            _bottom_pos.resize(resize)
            _south_pos.resize(resize)
            _west_pos.resize(resize)


## This method adds a rule to the up tile.
func add_up_rule(tile:int, element:int) -> void:
    add_edge_rule(tile, element, 0)

## This method removes a rule from the up tile.
func remove_up_rule_element(tile:int, element:int) -> void:
    remove_edge_rule_element(tile, element, 0)

## This method gets all the up indexth's data. It is recommended to store
## the return value and then use it. Calling this method multiple times
## will result in negative performance.
func get_up_rules(tile:int) -> Array[int]:
    return get_edge_rules(tile, 0)

## This method gets the indexth up size.
func get_up_size(tile:int) -> int:
    return get_edge_size(tile, 0)

## This method adds a rule to the north tile.
func add_north_rule(tile:int, element:int) -> void:
    add_edge_rule(tile, element, 1)

## This method removes a rule from the north tile.
func remove_north_rule_element(tile:int, element:int) -> void:
    remove_edge_rule_element(tile, element, 1)

## This method gets all the north indexth's data. It is recommended to store
## the return value and then use it. Calling this method multiple times
## will result in negative performance.
func get_north_rules(tile:int) -> Array[int]:
    return get_edge_rules(tile, 1)

## This method gets the indexth north size.
func get_north_size(tile:int) -> int:
    return get_edge_size(tile, 1)

## This method adds a rule to the east tile.
func add_east_rule(tile:int, element:int) -> void:
    add_edge_rule(tile, element, 2)

## This method removes a rule from the east tile.
func remove_east_rule_element(tile:int, element:int) -> void:
    remove_edge_rule_element(tile, element, 2)

## This method gets all the east indexth's data. It is recommended to store
## the return value and then use it. Calling this method multiple times
## will result in negative performance.
func get_east_rules(tile:int) -> Array[int]:
    return get_edge_rules(tile, 2)

## This method gets the indexth east size.
func get_east_size(tile:int) -> int:
    return get_edge_size(tile, 2)

## This method adds a rule to the bottom tile.
func add_bottom_rule(tile:int, element:int) -> void:
    add_edge_rule(tile, element, 3)

## This method removes a rule from the bottom tile.
func remove_bottom_rule_element(tile:int, element:int) -> void:
    remove_edge_rule_element(tile, element, 3)

## This method gets all the bottom indexth's data. It is recommended to store
## the return value and then use it. Calling this method multiple times
## will result in negative performance.
func get_bottom_rules(tile:int) -> Array[int]:
    return get_edge_rules(tile, 3)

## This method gets the indexth bottom size.
func get_bottom_size(tile:int) -> int:
    return get_edge_size(tile, 3)

## This method adds a rule to the south tile.
func add_south_rule(tile:int, element:int) -> void:
    add_edge_rule(tile, element, 4)

## This method removes a rule from the south tile.
func remove_south_rule_element(tile:int, element:int) -> void:
    remove_edge_rule_element(tile, element, 4)

## This method gets all the south indexth's data. It is recommended to store
## the return value and then use it. Calling this method multiple times
## will result in negative performance.
func get_south_rules(tile:int) -> Array[int]:
    return get_edge_rules(tile, 4)

## This method gets the indexth south size.
func get_south_size(tile:int) -> int:
    return get_edge_size(tile, 4)

## This method adds a rule to the west tile.
func add_west_rule(tile:int, element:int) -> void:
    add_edge_rule(tile, element, 5)

## This method removes a rule from the west tile.
func remove_west_rule_element(tile:int, element:int) -> void:
    remove_edge_rule_element(tile, element, 5)

## This method gets all the west indexth's data. It is recommended to store
## the return value and then use it. Calling this method multiple times
## will result in negative performance.
func get_west_rules(tile:int) -> Array[int]:
    return get_edge_rules(tile, 5)

## This method gets the indexth west size.
func get_west_size(tile:int) -> int:
    return get_edge_size(tile, 5)

## This method adds rules to the given edge.
## UP = 0
## North = 1
## East = 2
## Bottom = 3
## South = 4
## West = 5
func add_edge_rule(tile:int, element:int, edge:int) -> void:
    if edge == 0: # Up
        if _up_size[tile] == -1: # Checking if first insertion of tile
            _up_size[tile] = 0 # Making size 0 for first insertion for correct calculations
        
        _up_rules.insert(_up_pos[tile], element)
        _update_size_pos(tile, 1, 0)
    elif edge == 1: # North
        if _north_size[tile] == -1: # Checking if first insertion of tile
            _north_size[tile] = 0 # Making size 0 for first insertion for correct calculations
        
        _north_rules.insert(_north_pos[tile], element)
        _update_size_pos(tile, 1, 1)
    elif edge == 2: # East
        if _east_size[tile] == -1: # Checking if first insertion of tile
            _east_size[tile] = 0 # Making size 0 for first insertion for correct calculations
        
        _east_rules.insert(_east_pos[tile], element)
        _update_size_pos(tile, 1, 2)
    elif edge == 3: # Bottom
        if _bottom_size[tile] == -1: # Checking if first insertion of tile
            _bottom_size[tile] = 0 # Making size 0 for first insertion for correct calculations
        
        _bottom_rules.insert(_bottom_pos[tile], element)
        _update_size_pos(tile, 1, 3)
    elif edge == 4: # South
        if _south_size[tile] == -1: # Checking if first insertion of tile
            _south_size[tile] = 0 # Making size 0 for first insertion for correct calculations
        
        _south_rules.insert(_south_pos[tile], element)
        _update_size_pos(tile, 1, 4)
    elif edge == 5: # West
        if _west_size[tile] == -1: # Checking if first insertion of tile
            _west_size[tile] = 0 # Making size 0 for first insertion for correct calculations
        
        _west_rules.insert(_west_pos[tile], element)
        _update_size_pos(tile, 1, 5)

## This method removes a rules from the given cardianl.
## UP = 0
## North = 1
## East = 2
## Bottom = 3
## South = 4
## West = 5
func remove_edge_rule_element(tile:int, element:int, edge:int) -> void:
    if edge == 0: # Up
        if _up_size[tile] > 0: # Checking if up has at least 1 element
            _counter1 = 0
            while _counter1 < _up_size[tile]: # Loop for finding the element to remove
                if element == _up_rules[_up_pos[tile] + _counter1]: # Element found to remove
                    _up_rules.remove_at(_up_pos[tile] + _counter1)
                    _update_size_pos(tile, -1, 0)
                    break
                _counter1 += 1
    elif edge == 1: # North
        if _north_size[tile] > 0: # Checking if north has at least 1 element
            _counter1 = 0
            while _counter1 < _north_size[tile]: # Loop for finding the element to remove
                if element == _north_rules[_north_pos[tile] + _counter1]: # Element found to remove
                    _north_rules.remove_at(_north_pos[tile] + _counter1)
                    _update_size_pos(tile, -1, 1)
                    break
                _counter1 += 1
    elif edge == 2: # East
        if _east_size[tile] > 0: # Checking if east has at least 1 element
            _counter1 = 0
            while _counter1 < _east_size[tile]: # Loop for finding the element to remove
                if element == _east_rules[_east_pos[tile] + _counter1]: # Element found to remove
                    _east_rules.remove_at(_east_pos[tile] + _counter1)
                    _update_size_pos(tile, -1, 2)
                    break
                _counter1 += 1
    elif edge == 3: # Bottom
        if _bottom_size[tile] > 0: # Checking if bottom has at least 1 element
            _counter1 = 0
            while _counter1 < _bottom_size[tile]: # Loop for finding the element to remove
                if element == _bottom_rules[_bottom_pos[tile] + _counter1]: # Element found to remove
                    _bottom_rules.remove_at(_bottom_pos[tile] + _counter1)
                    _update_size_pos(tile, -1, 3)
                    break
                _counter1 += 1
    elif edge == 4: # South
        if _south_size[tile] > 0: # Checking if south has at least 1 element
            _counter1 = 0
            while _counter1 < _south_size[tile]: # Loop for finding the element to remove
                if element == _south_rules[_south_pos[tile] + _counter1]: # Element found to remove
                    _south_rules.remove_at(_south_pos[tile] + _counter1)
                    _update_size_pos(tile, -1, 4)
                    break
                _counter1 += 1
    elif edge == 5: # West
        if _west_size[tile] > 0: # Checking if west has at least 1 element
            _counter1 = 0
            while _counter1 < _west_size[tile]: # Loop for finding the element to remove
                if element == _west_rules[_west_pos[tile] + _counter1]: # Element found to remove
                    _west_rules.remove_at(_west_pos[tile] + _counter1)
                    _update_size_pos(tile, -1, 5)
                    break
                _counter1 += 1
            
## This method removes a rule from a tile with the given index. The index MUST be within the range.
## UP = 0
## North = 1
## East = 2
## Bottom = 3
## South = 4
## West = 5
func remove_edge_rule_at(tile:int, index:int, edge:int) -> void:
    if edge == 0: # Up
        if _up_size[tile] > 0: # Checking up up has at least 1 element.
            if (_up_pos[tile] + index) < (_up_pos[tile] + _up_size[tile]): # Checking if index is within range
                _up_rules.remove_at(_up_pos[tile] + index) # Removing indexth element
                _update_size_pos(tile, -1, 0)
    elif edge == 1: # North
        if _north_size[tile] > 0: # Checking up up has at least 1 element.
            if (_north_pos[tile] + index) < (_north_pos[tile] + _north_size[tile]): # Checking if index is within range
                _north_rules.remove_at(_north_pos[tile] + index) # Removing indexth element
                _update_size_pos(tile, -1, 1)
    elif edge == 2: # East
        if _east_size[tile] > 0: # Checking up up has at least 1 element.
            if (_east_pos[tile] + index) < (_east_pos[tile] + _east_size[tile]): # Checking if index is within range
                _east_rules.remove_at(_east_pos[tile] + index) # Removing indexth element
                _update_size_pos(tile, -1, 2)
    elif edge == 3: # Bottom
        if _bottom_size[tile] > 0: # Checking up up has at least 1 element.
            if (_bottom_pos[tile] + index) < (_bottom_pos[tile] + _bottom_size[tile]): # Checking if index is within range
                _bottom_rules.remove_at(_bottom_pos[tile] + index) # Removing indexth element
                _update_size_pos(tile, -1, 3)
    elif edge == 4: # South
        if _south_size[tile] > 0: # Checking up up has at least 1 element.
            if (_south_pos[tile] + index) < (_south_pos[tile] + _south_size[tile]): # Checking if index is within range
                _south_rules.remove_at(_south_pos[tile] + index) # Removing indexth element
                _update_size_pos(tile, -1, 4)
    elif edge == 5: # West
        if _west_size[tile] > 0: # Checking up up has at least 1 element.
            if (_west_pos[tile] + index) < (_west_pos[tile] + _west_size[tile]): # Checking if index is within range
                _west_rules.remove_at(_west_pos[tile] + index) # Removing indexth element
                _update_size_pos(tile, -1, 5)

## This method checks if the given element exists in the given tile.
func has_element(tile:int, element:int, edge:int) -> bool:
    if edge == 0: # UP
        if _up_size[tile] > 0: # Checking if at least 1 element exists
            _counter1 = 0
            while _counter1 < _up_size[tile]: # Loop to check if element exists
                if _up_rules[_up_pos[tile] + _counter1] == element: # Condition for element existing
                    return true
                _counter1 += 1
    elif edge == 1: # NORTH
        if _north_size[tile] > 0: # Checking if at least 1 element exists
            _counter1 = 0
            while _counter1 < _north_size[tile]: # Loop to check if element exists
                if _north_rules[_north_pos[tile] + _counter1] == element: # Condition for element existing
                    return true
                _counter1 += 1
    elif edge == 2: # EAST
        if _east_size[tile] > 0: # Checking if at least 1 element exists
            _counter1 = 0
            while _counter1 < _east_size[tile]: # Loop to check if element exists
                if _east_rules[_east_pos[tile] + _counter1] == element: # Condition for element existing
                    return true
                _counter1 += 1
    elif edge == 3: # BOTTOM
        if _bottom_size[tile] > 0: # Checking if at least 1 element exists
            _counter1 = 0
            while _counter1 < _bottom_size[tile]: # Loop to check if element exists
                if _bottom_rules[_bottom_pos[tile] + _counter1] == element: # Condition for element existing
                    return true
                _counter1 += 1
    elif edge == 4: # SOUTH
        if _south_size[tile] > 0: # Checking if at least 1 element exists
            _counter1 = 0
            while _counter1 < _south_size[tile]: # Loop to check if element exists
                if _south_rules[_south_pos[tile] + _counter1] == element: # Condition for element existing
                    return true
                _counter1 += 1
    elif edge == 5: # WEST
        if _west_size[tile] > 0: # Checking if at least 1 element exists
            _counter1 = 0
            while _counter1 < _west_size[tile]: # Loop to check if element exists
                if _west_rules[_west_pos[tile] + _counter1] == element: # Condition for element existing
                    return true
                _counter1 += 1

    return false

## This method gets all rules for the indexth edge.
## UP = 0
## North = 1
## East = 2
## Bottom = 3
## South = 4
## West = 5
func get_edge_rules(tile:int, edge:int) -> Array[int]:
    _temp_data.clear()
    _counter1 = 0

    if edge == 0: # Up
        while _counter1 < _up_size[tile]: # Loop for adding all the elements
            _temp_data.append(_up_rules[_up_pos[tile] + _counter1])
            _counter1 += 1
    elif edge == 1: # North
        while _counter1 < _north_size[tile]: # Loop for adding all the elements
            _temp_data.append(_north_rules[_north_pos[tile] + _counter1])
            _counter1 += 1
    elif edge == 2: # East
        while _counter1 < _east_size[tile]: # Loop for adding all the elements
            _temp_data.append(_east_rules[_east_pos[tile] + _counter1])
            _counter1 += 1
    elif edge == 3: # Bottom
        while _counter1 < _bottom_size[tile]: # Loop for adding all the elements
            _temp_data.append(_bottom_rules[_bottom_pos[tile] + _counter1])
            _counter1 += 1
    elif edge == 4: # South
        while _counter1 < _south_size[tile]: # Loop for adding all the elements
            _temp_data.append(_south_rules[_south_pos[tile] + _counter1])
            _counter1 += 1
    elif edge == 5: # West
        while _counter1 < _west_size[tile]: # Loop for adding all the elements
            _temp_data.append(_west_rules[_west_pos[tile] + _counter1])
            _counter1 += 1

    return _temp_data.duplicate()

## This method gets the size for the indexth cardinal.
## UP = 0
## North = 1
## East = 2
## Bottom = 3
## South = 4
## West = 5
func get_edge_size(tile:int, edge:int) -> int:
    return (_up_size[tile] if edge == 0 else _north_size[tile] if edge == 1 else 
            _east_size[tile] if edge == 2 else _bottom_size[tile] if edge == 3 else
            _south_size[tile] if edge == 4 else _west_size[tile] if edge == 5 else -1)

## This method updates the size and pos of an edge.
## UP = 0
## North = 1
## East = 2
## Bottom = 3
## South = 4
## West = 5
func _update_size_pos(tile:int, dir:int, edge:int) -> void:
    if edge == 0: # Up
        _up_size[tile] += dir # Updating size
        _counter_pos = tile + 1
        while _counter_pos < _up_pos.size(): # Loop for updating pos
            _up_pos[_counter_pos] = 0 if (_up_pos[_counter_pos] + dir) <= 0 else _up_pos[_counter_pos] + dir
            _counter_pos += 1
    elif edge == 1: # North
        _north_size[tile] += dir # Updating size
        _counter_pos = tile + 1
        while _counter_pos < _north_pos.size(): # Loop for updating pos
            _north_pos[_counter_pos] = 0 if (_north_pos[_counter_pos] + dir) <= 0 else _north_pos[_counter_pos] + dir
            _counter_pos += 1
    elif edge == 2: # East
        _east_size[tile] += dir # Updating size
        _counter_pos = tile + 1
        while _counter_pos < _east_pos.size(): # Loop for updating pos
            _east_pos[_counter_pos] = 0 if (_east_pos[_counter_pos] + dir) <= 0 else _east_pos[_counter_pos] + dir
            _counter_pos += 1
    elif edge == 3: # Bottom
        _bottom_size[tile] += dir # Updating size
        _counter_pos = tile + 1
        while _counter_pos < _bottom_pos.size(): # Loop for updating pos
            _bottom_pos[_counter_pos] = 0 if (_bottom_pos[_counter_pos] + dir) <= 0 else _bottom_pos[_counter_pos] + dir
            _counter_pos += 1
    elif edge == 4: # South
        _south_size[tile] += dir # Updating size
        _counter_pos = tile + 1
        while _counter_pos < _south_pos.size(): # Loop for updating pos
            _south_pos[_counter_pos] = 0 if (_south_pos[_counter_pos] + dir) <= 0 else _south_pos[_counter_pos] + dir
            _counter_pos += 1
    elif edge == 5: # West
        _west_size[tile] += dir # Updating size
        _counter_pos = tile + 1
        while _counter_pos < _west_pos.size(): # Loop for updating pos
            _west_pos[_counter_pos] = 0 if (_west_pos[_counter_pos] + dir) <= 0 else _west_pos[_counter_pos] + dir
            _counter_pos += 1