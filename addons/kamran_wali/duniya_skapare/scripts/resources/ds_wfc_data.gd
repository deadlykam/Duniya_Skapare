@tool
class_name DS_WFC_Data
extends "res://addons/kamran_wali/duniya_skapare/scripts/resources/ds_base_resource.gd"

@export_category("DS WFC Data Properties")
@export_group("Number Of Tiles Properties")
@export var _number_of_tiles:= 1

@export_group("Tile Names Properties")
@export var _tile_names: Array[String]

@export_group("Tile Rules Properties")
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

@export_group("Invalid Combination Properites")
@export var _invalid_combos: Array[DS_InvalidComboManager]

var _temp_data: Array[int]
var _temp_data2: Array[int]
var _tile:= -1
var _counter1:= -1
var _counter2:= -1
var _counter3:= -1
var _counter_pos:= -1

## This method sets the number of tile value.
func set_number_of_tiles(value:int) -> void: _number_of_tiles = value

## This method gets the number of tile value.
func get_number_of_tiles() -> int: return _number_of_tiles

## This method updates the name of the indexth tile.
func update_tile_name(name:String, index:int) -> void: _tile_names[index] = name

## This method gets the indexth tile name.
func get_tile_name(index:int) -> String: return _tile_names[index]

## This method gets all the tile name array by duplicating it.
func get_tile_names() -> Array[String]: return _tile_names.duplicate()

#region Invalid Combinations
## This method adds an invalid combo element to the given tile.
func add_invalid_combo(tile:int, element:DS_InvalidComboData) -> void: _invalid_combos[tile].add_element(element)

## This method removes an invalid combo element from the given tile.
func remove_invalid_combo(tile:int, element:DS_InvalidComboData) -> void: _invalid_combos[tile].remove_element(element)

## This method removes the indexth invalid combo element from the given tile.
func remove_invalid_combo_index(tile:int, index:int) -> void: _invalid_combos[tile].remove_element_index(index)

## This method gets the indexth invalid combo element of the given tile.
func get_invalid_combo_element(tile:int, index:int) -> DS_InvalidComboData: return _invalid_combos[tile].get_element(index)

## This method checks if the given invalid combo element already exists for the given tile.
func has_invalid_combo_element(tile:int, element:DS_InvalidComboData) -> bool:
    _counter1 = 0
    while _counter1 < _invalid_combos[tile].get_size(): # Loop to check if element already exists
        if _invalid_combos[tile].get_element(_counter1).is_equal_to(element): return true # Element exists
        _counter1 += 1
    return false

## This method gets the index of the invalid combo element data IF it exists otherwise -1 is returned
func get_invalid_combo_element_index(tile:int, element:DS_InvalidComboData) -> int:
    #region NOTE get_invalid_combo_element_index():
    #           The counter from the method has_invalid_combo_element() is returned instead
    #           if an element exists. This is because that method already does the searching
    #           and stops the _counter1 right when an element is found. So NO need to re-write
    #           the logic for searching again. -1 is returend if that method returns false.
    #endregion
    if has_invalid_combo_element(tile, element): return _counter1
    return -1

## This method gets the size for the invalid combo element's data.
func get_invalid_combo_element_size(tile:int) -> int: return _invalid_combos[tile].get_size()

## This method gets the size of the invalid combo data.
func get_invalid_combo_data_size() -> int: return _invalid_combos.size()
#endregion

#region Rules
## This method adds a rule to the up tile.
func add_up_rule(tile:int, element:int) -> void: add_edge_rule(tile, element, 0)

## This method removes a rule from the up tile.
func remove_up_rule_element(tile:int, element:int) -> void: remove_edge_rule_element(tile, element, 0)

## This method gets all the up indexth's data. It is recommended to store
## the return value and then use it. Calling this method multiple times
## will result in negative performance.
func get_up_rules(tile:int) -> Array[int]: return get_edge_rules(tile, 0)

## This method gets the indexth up size.
func get_up_size(tile:int) -> int: return get_edge_size(tile, 0)

## This method adds a rule to the north tile.
func add_north_rule(tile:int, element:int) -> void: add_edge_rule(tile, element, 1)

## This method removes a rule from the north tile.
func remove_north_rule_element(tile:int, element:int) -> void: remove_edge_rule_element(tile, element, 1)

## This method gets all the north indexth's data. It is recommended to store
## the return value and then use it. Calling this method multiple times
## will result in negative performance.
func get_north_rules(tile:int) -> Array[int]: return get_edge_rules(tile, 1)

## This method gets the indexth north size.
func get_north_size(tile:int) -> int: return get_edge_size(tile, 1)

## This method adds a rule to the east tile.
func add_east_rule(tile:int, element:int) -> void: add_edge_rule(tile, element, 2)

## This method removes a rule from the east tile.
func remove_east_rule_element(tile:int, element:int) -> void: remove_edge_rule_element(tile, element, 2)

## This method gets all the east indexth's data. It is recommended to store
## the return value and then use it. Calling this method multiple times
## will result in negative performance.
func get_east_rules(tile:int) -> Array[int]: return get_edge_rules(tile, 2)

## This method gets the indexth east size.
func get_east_size(tile:int) -> int: return get_edge_size(tile, 2)

## This method adds a rule to the bottom tile.
func add_bottom_rule(tile:int, element:int) -> void: add_edge_rule(tile, element, 3)

## This method removes a rule from the bottom tile.
func remove_bottom_rule_element(tile:int, element:int) -> void: remove_edge_rule_element(tile, element, 3)

## This method gets all the bottom indexth's data. It is recommended to store
## the return value and then use it. Calling this method multiple times
## will result in negative performance.
func get_bottom_rules(tile:int) -> Array[int]: return get_edge_rules(tile, 3)

## This method gets the indexth bottom size.
func get_bottom_size(tile:int) -> int: return get_edge_size(tile, 3)

## This method adds a rule to the south tile.
func add_south_rule(tile:int, element:int) -> void: add_edge_rule(tile, element, 4)

## This method removes a rule from the south tile.
func remove_south_rule_element(tile:int, element:int) -> void: remove_edge_rule_element(tile, element, 4)

## This method gets all the south indexth's data. It is recommended to store
## the return value and then use it. Calling this method multiple times
## will result in negative performance.
func get_south_rules(tile:int) -> Array[int]: return get_edge_rules(tile, 4)

## This method gets the indexth south size.
func get_south_size(tile:int) -> int: return get_edge_size(tile, 4)

## This method adds a rule to the west tile.
func add_west_rule(tile:int, element:int) -> void: add_edge_rule(tile, element, 5)

## This method removes a rule from the west tile.
func remove_west_rule_element(tile:int, element:int) -> void: remove_edge_rule_element(tile, element, 5)

## This method gets all the west indexth's data. It is recommended to store
## the return value and then use it. Calling this method multiple times
## will result in negative performance.
func get_west_rules(tile:int) -> Array[int]: return get_edge_rules(tile, 5)

## This method gets the indexth west size.
func get_west_size(tile:int) -> int: return get_edge_size(tile, 5)

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
func has_rule_element(tile:int, element:int, edge:int) -> bool:
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

## This method gets all the rules available.
func get_all_rules() -> Array[int]:
    _temp_data.clear()
    _counter1 = 0

    while _counter1 < _tile_names.size():
        _temp_data.append(_counter1)
        _counter1 += 1
    
    return _temp_data.duplicate()

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

## This method gets all the rules for the given tile.
func get_tile_rules(tile:int) -> Array[int]:
    _temp_data2.clear()
    _counter2 = 0 # Index counter for going through all the edges

    while _counter2 < 6: # Loop for going through all the edges
        _temp_data = get_edge_rules(tile, _counter2)
        _counter3 = 0 # Index counter for going through all the edge data
        while _counter3 < _temp_data.size(): # Loop for going through all the edge data
            if !_temp_data2.has(_temp_data[_counter3]): # Checking if the current data is NOT added
                if _temp_data2.is_empty(): _temp_data2.append(_temp_data[_counter3]) # Adding the first data
                else:
                    _counter1 = 0 # Index for going through all the rules data
                    while _counter1 < _temp_data2.size(): # Loop for going through all the rules data
                        if _temp_data[_counter3] < _temp_data2[_counter1]: # Checking if the current data is less than added data
                            _temp_data2.insert(_counter1, _temp_data[_counter3]) # Inserting the lesser data in front
                            break
                        _counter1 += 1
                    if _counter1 == _temp_data2.size(): _temp_data2.append(_temp_data[_counter3]) # Adding the data to the back
            _counter3 += 1
        _counter2 += 1

    return _temp_data2.duplicate()

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
#endregion

#region Resets
## This method resizes the data.
func data_resize(resize:int) -> void:
    _number_of_tiles = resize # Updating number of tiles to resize value
    _tile_names.resize(resize) # Resizing tile names
    _invalid_combos.resize(resize) # Resizing invalid combos

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

## This method resets the data.
func data_reset() -> void:
    _number_of_tiles = 1 # Resetting number of tiles

    # Resetting tile names
    _tile_names.resize(1)
    _tile_names[0] = "Tile"

    # Resetting invalid combinations
    _invalid_combos.resize(1)
    if _invalid_combos[0] != null: _invalid_combos[0].reset_data() # Resetting data if NOT null
    else: _invalid_combos[0] = DS_InvalidComboManager.new() # Creating new manager if null

    # Removing all the rules
    _up_rules.resize(0)
    _north_rules.resize(0)
    _east_rules.resize(0)
    _bottom_rules.resize(0)
    _south_rules.resize(0)
    _west_rules.resize(0)

    # Resetting the pos size and value
    _up_pos.resize(1)
    _up_pos[0] = 0
    _north_pos.resize(1)
    _north_pos[0] = 0
    _east_pos.resize(1)
    _east_pos[0] = 0
    _bottom_pos.resize(1)
    _bottom_pos[0] = 0
    _south_pos.resize(1)
    _south_pos[0] = 0
    _west_pos.resize(1)
    _west_pos[0] = 0

    # Resetting the size size and value
    _up_size.resize(1)
    _up_size[0] = 0
    _north_size.resize(1)
    _north_size[0] = 0
    _east_size.resize(1)
    _east_size[0] = 0
    _bottom_size.resize(1)
    _bottom_size[0] = 0
    _south_size.resize(1)
    _south_size[0] = 0
    _west_size.resize(1)
    _west_size[0] = 0
#endregion

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