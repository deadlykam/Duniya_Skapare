@tool
class_name DS_WFCRulesData
extends Resource

@export_group("Tile Rules Properties")
@export var _up_rules: Array[int]
@export var _north_rules: Array[int]
@export var _east_rules: Array[int]
@export var _bottom_rules: Array[int]
@export var _south_rules: Array[int]
@export var _west_rules: Array[int]

# This method adds rules to the given edge.
## UP = 0
## North = 1
## East = 2
## Bottom = 3
## South = 4
## West = 5
func add_edge_rule(element:int, edge:int) -> void:
    if edge == 0: _up_rules.append(element) # Adding rules to the up rules
    elif edge == 1: _north_rules.append(element) # Adding rules to the north rules
    elif edge == 2: _east_rules.append(element) # Adding rules to the east rules
    elif edge == 3: _bottom_rules.append(element) # Adding rules to the bottom rules
    elif edge == 4: _south_rules.append(element) # Adding rules to the south rules
    elif edge == 5: _west_rules.append(element) # Adding rules to the west rules

## This method removes a rule from the given index. The index MUST be within the range.
## UP = 0
## North = 1
## East = 2
## Bottom = 3
## South = 4
## West = 5
func remove_edge_rule_at(index:int, edge:int) -> void:
    if edge == 0: _up_rules.remove_at(index) # Removing rules in the up rules
    elif edge == 1: _north_rules.remove_at(index) # Removing rules in the north rules
    elif edge == 2: _east_rules.remove_at(index) # Removing rules in the east rules
    elif edge == 3: _bottom_rules.remove_at(index) # Removing rules in the bottom rules
    elif edge == 4: _south_rules.remove_at(index) # Removing rules in the south rules
    elif edge == 5: _west_rules.remove_at(index) # Removing rules in the west rules

## This method gets all the rules for the given edge index.
## UP = 0
## North = 1
## East = 2
## Bottom = 3
## South = 4
## West = 5
func get_edge_rules(edge:int) -> Array[int]:
    return (_up_rules.duplicate() if edge == 0 else # Getting up rules
            _north_rules.duplicate() if edge == 1 else # Getting north rules
            _east_rules.duplicate() if edge == 2 else # Getting east rules
            _bottom_rules.duplicate() if edge == 3 else # Getting bottom rules
            _south_rules.duplicate() if edge == 4 else # Getting south rules
            _west_rules.duplicate() if edge == 5 else # Getting west rules
            null) # Returning null for invalid edge index

## This method gets the size for the indexth cardinal.
## UP = 0
## North = 1
## East = 2
## Bottom = 3
## South = 4
## West = 5
func get_edge_size(edge:int) -> int:
    return (_up_rules.size() if edge == 0 else # Getting the up size
            _north_rules.size() if edge == 1 else # Getting the north size
            _east_rules.size() if edge == 2 else # Getting the east size
            _bottom_rules.size() if edge == 3 else # Getting the bottom size
            _south_rules.size() if edge == 4 else # Getting the south size
            _west_rules.size() if edge == 5 else # Getting the west size
            -1) # Getting the invalid size

## This method resets the data.
func data_reset() -> void:
    _up_rules.resize(0)
    _north_rules.resize(0)
    _east_rules.resize(0)
    _bottom_rules.resize(0)
    _south_rules.resize(0)
    _west_rules.resize(0)