@tool
extends Node

@export_category("Tile Start")
@export var _tiles: Array[DS_TileInfo]:
    set(p_tiles):
        if _tiles != p_tiles:
            _tiles = p_tiles
            update_configuration_warnings()

var _generator: DS_BaseGen
var _c_1: int
var _counter: int
var _parent_search: Node # For finding the parent with the generator
var _name_array_empty: Array[String]

func _get_configuration_warnings() -> PackedStringArray:
    var warnings: PackedStringArray

    _generator = _get_generator()
    if _generator == null:
        warnings.append("Generator: Please give a parent containing the generator script")

    if _generator != null: # Checking if the generator is NOT null
        if _tiles.size() != 0: # Checking if at least 1 tile is given
            _counter = 0
            while _counter < _tiles.size(): # Loop for setting the data for the tiles
                if _tiles[_counter] != null: # Tile has been initialized
                    _tiles[_counter].set_data( # Setting the data
                        _tiles,
                        _generator.get_tile_names() if _generator != null else _name_array_empty,
                        _generator.get_grid().get_size() if _generator != null else -1,
                        _counter
                    )
                _counter += 1
    
    return warnings

func _ready() -> void:
    if !Engine.is_editor_hint():
        if _generator == null: _generator = _get_generator() # Searching and storing the generator

        if _generator != null: # Checking if generator is given
            _c_1 = 0
            while _c_1 < _tiles.size(): # Loop for adding all the tiles
                _generator.add_start_tile(_tiles[_c_1]) # Adding the tiles
                _c_1 += 1

## This method gets the generator.
func _get_generator() -> DS_BaseGen:
    _parent_search = get_parent() # Setting the first parent

    while true: # Loop for finding the parent with the generator
        if _parent_search != null: # Checking if parent is NOT null
            if _parent_search.has_method("_is_gen"): return _parent_search # Parent with generator found
            _parent_search = _parent_search.get_parent() # Getting the next parent
        else: break # No Parent found, stopping the search
    
    return null