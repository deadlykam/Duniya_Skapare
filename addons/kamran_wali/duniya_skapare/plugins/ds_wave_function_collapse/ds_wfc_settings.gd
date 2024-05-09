@tool
extends "res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_base.gd"

# Constants
const DS_WAVE_FUNCTION_COLLAPSE_UI = preload("res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_wave_function_collapse_ui.gd")

# Templates
var _template_tile_name_ui = preload("res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/tile_name_ui.tscn")

# Properties from the scene
var _tile_container: Control
var _txt_not: LineEdit
var _btn_not_ok: Button

# Properties for internal usage ONLY
var _ds_wave_function_collapse_ui: DS_WAVE_FUNCTION_COLLAPSE_UI
var _number_of_tiles:= -1
var _tiles_current:= 0
var _counter1:= -1
var _temp: Node # Needed for instancing objects
var _counter_id:= 0 # For storing the current id number

func _enter_tree() -> void:
    _tile_container = $Holder/Tile_Container
    _txt_not = $Holder/NOT_Container/Txt_NoT
    _btn_not_ok = $Holder/NOT_Container/Btn_NOT_OK

## This method initializes the edge rule ui.
func init(ds_wave_function_collapse_ui:DS_WAVE_FUNCTION_COLLAPSE_UI) -> void:
    _ds_wave_function_collapse_ui = ds_wave_function_collapse_ui

func _ready() -> void:
    _setup() # Setting up the UI at start up

## This method updates the name of the data.
func update_tile_name_data(name:String, index:int) -> void:
    get_data()._data_wfc_names.update_element(name, index)
    _show_save_msg()

func _on_btn_not_ok_pressed() -> void:
    if _number_of_tiles != int(_txt_not.text): # Condition to check if to update the data
        _number_of_tiles = int(_txt_not.text)
        _update_tile_name_inputs(false) # Updating the number of tile name inputs to show
        _update_rules_data_size() # Updating the size of the rules data

func _on_txt_no_t_text_changed(new_text:String) -> void:
    if (new_text.is_valid_int() && new_text != "0" && !new_text.contains("-")
        && !new_text.contains("+")): # Condition for showing the ok button
        _set_font_colour(_txt_not, Color.WHITE)
        _btn_not_ok.visible = true
    else: # Condition for hiding the ok button
        _set_font_colour(_txt_not, Color.RED)
        _btn_not_ok.visible = false

## This method sets up the UI.
func _setup() -> void:
    _txt_not.text = str(get_data().get_wfc_number_of_tiles()) # Setting the txt_not value to number of tiles
    _number_of_tiles = get_data().get_wfc_number_of_tiles()
    _update_tile_name_inputs(true)

## This method updates the number of tile name inputs to show.
func _update_tile_name_inputs(is_set_name:bool) -> void:
    get_data()._data_wfc_not.set_value(_number_of_tiles)
    get_data()._data_wfc_names.data_resize(_number_of_tiles)
    
    if _number_of_tiles < _tiles_current: # Condition for removing children
        _counter1 = _tile_container.get_child_count() - 1 # Starting from the farthest child
        while _counter1 >= _number_of_tiles: # Loop for removing children
            _remove_tile_input(_counter1)
            _counter1 -= 1
    elif _number_of_tiles > _tiles_current: # Condition for adding children
        _counter1 = 0
        while _counter1 < (_number_of_tiles - _tiles_current): # Loop for adding children
            _temp = _template_tile_name_ui.instantiate()
            _temp.setup(self, _counter_id) # Setting the tile name UI
            if is_set_name: _temp.setup_name(get_data()._data_wfc_names.get_element(_counter1)) # Setting the name
            _tile_container.add_child(_temp)
            _temp = null
            _counter_id += 1 # Increasing the tile id
            _counter1 += 1
        
    _tiles_current = _number_of_tiles # Updating current tile numbers
    if !is_set_name: _show_save_msg() # Showing unsaved messageks

## This method resizes the rules data to number of tiles
func _update_rules_data_size() -> void:
    get_data()._data_wfc_rules.data_resize(_number_of_tiles)

## This method creates a new tile input.
func _add_new_tile_input() -> void:
    _temp = _template_tile_name_ui.instantiate()
    _temp.setup(self, _counter_id) # Setting the tile name UI
    _tile_container.add_child(_temp)
    _temp = null
    _counter_id += 1 # Increasing the tile id

## This method removes the indexth tile input.
func _remove_tile_input(index:int) -> void:
    _tile_container.get_child(index).queue_free() # Removing the child
    _counter_id -= 1 # Decreasing the tile id
    
## This method sets the font colour for the control.
func _set_font_colour(control:Control, colour:Color) -> void:
    control.add_theme_color_override("font_color", colour)

## This method shows the unsaved messages.
func _show_save_msg() -> void:
    _ds_wave_function_collapse_ui.show_unsaved_message("Unsaved Chagnes!")