@tool
class_name DS_WFC_Data
extends "res://addons/kamran_wali/duniya_skapare/scripts/resources/ds_base_resource.gd"

@export_category("DS WFC Data Properties")
@export_group("Number Of Tiles Properties")
@export var _number_of_tiles:= 1

@export_group("Tile Names Properties")
@export var _tile_names: Array[String]

@export_group("Tile Rules Properties")
@export var _tile_rules: Array[DS_WFCRulesData]

@export_group("Invalid Combination Properites")
@export var _invalid_combos: Array[DS_InvalidComboManager]

var _temp_data: Array[int]
var _temp_data2: Array[int]
var _tile:= -1
var _counter1:= -1
var _counter2:= -1
var _counter3:= -1
var _size_pre_rules:= -1 # For storing the previous size
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

## This method updates the tile's indexth element.
func update_invalid_combo(tile:int, element:DS_InvalidComboData, index:int) -> void: _invalid_combos[tile].update_element_index(element, index)

## This method removes the indexth invalid combo element from the given tile.
func remove_invalid_combo_index(tile:int, index:int) -> void: _invalid_combos[tile].remove_element_index(index)

## This method gets the indexth invalid combo element of the given tile.
func get_invalid_combo_element(tile:int, index:int) -> DS_InvalidComboData: return _invalid_combos[tile].get_element(index)

## This method checks if the given invalid combo element already exists for the given tile but also ignores the given index.
func has_invalid_combo_element_ignore_index(tile:int, element:DS_InvalidComboData, _ignore_index:int) -> bool:
    _counter1 = 0
    while _counter1 < _invalid_combos[tile].get_size(): # Loop to check if element already exists
        if _invalid_combos[tile].get_element(_counter1).is_equal_to(element) and _counter1 != _ignore_index: return true # Element exists
        _counter1 += 1
    return false

## This method checks if the given invalid combo element already exists for the given tile.
func has_invalid_combo_element(tile:int, element:DS_InvalidComboData) -> bool:
    return has_invalid_combo_element_ignore_index(tile, element, -1)

## This method gets the index of the invalid combo element data IF it exists otherwise -1 is returned. Also ignores the given index.
func get_invalid_combo_element_index_ignore_index(tile:int, element:DS_InvalidComboData, ignore_index:int) -> int:
    #region NOTE get_invalid_combo_element_index_ignore_index():
    #           The counter from the method has_invalid_combo_element_ignore_index() is returned instead
    #           if an element exists. This is because that method already does the searching
    #           and stops the _counter1 right when an element is found. So NO need to re-write
    #           the logic for searching again. -1 is returend if that method returns false.
    #endregion
    if has_invalid_combo_element_ignore_index(tile, element, ignore_index): return _counter1
    return -1

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

## This method adds rules to the given edge for the given tile.
## UP = 0
## North = 1
## East = 2
## Bottom = 3
## South = 4
## West = 5
func add_edge_rule(tile:int, element:int, edge:int) -> void: _tile_rules[tile].add_edge_rule(element, edge)

## This method removes a rules from the given cardianl.
## UP = 0
## North = 1
## East = 2
## Bottom = 3
## South = 4
## West = 5
func remove_edge_rule_element(tile:int, element:int, edge:int) -> void:
    _temp_data.clear() # Clearing any previous data
    _temp_data = _tile_rules[tile].get_edge_rules(edge) # Getting new edge data
    _counter1 = 0
    while _counter1 < _temp_data.size(): # Loop for finding the element to remove
        if element == _temp_data[_counter1]: # Element found to remove
            remove_edge_rule_at(tile, _counter1, edge) # Removing element
            break
        _counter1 += 1
            
## This method removes a rule from a tile with the given index. The index MUST be within the range.
## UP = 0
## North = 1
## East = 2
## Bottom = 3
## South = 4
## West = 5
func remove_edge_rule_at(tile:int, index:int, edge:int) -> void: _tile_rules[tile].remove_edge_rule_at(index, edge)

## This method checks if the given element exists in the given tile.
func has_rule_element(tile:int, element:int, edge:int) -> bool:
    _temp_data.clear() # Removing any previous data
    _temp_data = _tile_rules[tile].get_edge_rules(edge) # Getting new edge data
    _counter1 = 0
    while _counter1 < _temp_data.size(): # Loop to check if element exists
        if _temp_data[_counter1] == element: return true # Condition for element existing
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
func get_edge_rules(tile:int, edge:int) -> Array[int]: return _tile_rules[tile].get_edge_rules(edge)

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
func get_edge_size(tile:int, edge:int) -> int: return _tile_rules[tile].get_edge_size(edge)
#endregion

#region Resets
## This method resizes the data.
func data_resize(resize:int) -> void:
    _number_of_tiles = resize # Updating number of tiles to resize value
    _tile_names.resize(resize) # Resizing tile names
    _size_pre_rules = _tile_rules.size() # Storing the previous resize value for the tile rules
    _tile_rules.resize(resize) # Resizing tile rules
    _invalid_combos.resize(resize) # Resizing invalid combos

    if resize < _size_pre_rules: # Condition for removing rules
        _counter1 = 0 # Act as _tile_rules index
        while _counter1 < resize: # Loop for going through all the tiles
            _counter2 = 0 # Act as edge index
            while _counter2 < 6: # Loop for going through all the edges
                _temp_data.clear()
                _temp_data = _tile_rules[_counter1].get_edge_rules(_counter2) # Getting the edge rules
                _counter3 = _temp_data.size() - 1 # Act as _temp_data index
                while _counter3 >= 0: # Loop for going through all the rules
                    if _temp_data[_counter3] >= resize: remove_edge_rule_at(_counter1, _counter3, _counter2) # Condition for removing rule
                    _counter3 -= 1
                _counter2 += 1
            _counter1 += 1
    elif resize > _size_pre_rules: # Condition for adding rules
        _counter1 = _size_pre_rules # Starting index from previous size
        while _counter1 < resize: # Loop for creating new data
            _tile_rules[_counter1] = DS_WFCRulesData.new() # Creating new data
            _counter1 += 1

## This method resets the data.
func data_reset() -> void:
    _number_of_tiles = 1 # Resetting number of tiles

    # Resetting tile names
    _tile_names.resize(1)
    _tile_names[0] = "Tile"

    # Resetting tile rules
    _tile_rules.resize(1)
    if _tile_rules[0] != null: _tile_rules[0].data_reset()
    else: _tile_rules[0] = DS_WFCRulesData.new() # Creating new rules data if null

    # Resetting invalid combinations
    _invalid_combos.resize(1)
    if _invalid_combos[0] != null: _invalid_combos[0].reset_data() # Resetting data if NOT null
    else: _invalid_combos[0] = DS_InvalidComboManager.new() # Creating new manager if null
#endregion