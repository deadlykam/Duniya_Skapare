@tool
extends "res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/ds_base.gd"

# Templates
var _template_tile_name_ui = preload("res://addons/kamran_wali/duniya_skapare/plugins/ds_wave_function_collapse/tile_name_ui.tscn")

# Properties from the scene
var _tile_container: Control
var _txt_not: LineEdit
var _btn_not_ok: Button

# Properties for internal usage ONLY
var _number_of_tiles:= -1
var _tiles_current:= 0
var _counter1:= -1
var _temp: Node # Needed for instancing objects
var _counter_id:= 0 # For storing the current id number

func _enter_tree() -> void:
    _tile_container = $Holder/Tile_Container
    _txt_not = $Holder/NOT_Container/Txt_NoT
    _btn_not_ok = $Holder/NOT_Container/Btn_NOT_OK

func _ready() -> void: setup() # Setting up the UI at start up

## This method sets up the UI.
func setup() -> void:
    _remove_all_inputs() # Making sure all inputs are removed at the start
    _txt_not.text = str(get_data().get_number_of_tiles()) # Setting the txt_not value to number of tiles
    _number_of_tiles = get_data().get_number_of_tiles()
    _update_tile_name_inputs(_number_of_tiles, true)

## This method updates the name of the data.
func update_tile_name_data(name:String, index:int) -> void:
    get_data().update_tile_name(name, index)
    _show_save_msg()

## This method resets the UI to its default state.
func reset() -> void:
    _update_tile_name_inputs(1, false)
    _tile_container.get_child(0).set_txt_name(get_data().get_tile_name(0))
    _txt_not.text = str(get_data().get_number_of_tiles())

func _on_btn_not_ok_pressed() -> void:
    if _number_of_tiles != int(_txt_not.text): # Condition to check if to update the data
        _update_tile_name_inputs(int(_txt_not.text), false) # Updating the number of tile name inputs to show
        get_data().data_resize(_number_of_tiles) # Resizing the entire data

func _on_txt_no_t_text_changed(new_text:String) -> void:
    if (new_text.is_valid_int() && new_text != "0" && !new_text.contains("-")
        && !new_text.contains("+")): # Condition for showing the ok button
        _set_font_colour(_txt_not, Color.WHITE)
        _btn_not_ok.visible = true
    else: # Condition for hiding the ok button
        _set_font_colour(_txt_not, Color.RED)
        _btn_not_ok.visible = false

## This method updates the number of tile name inputs to show.
func _update_tile_name_inputs(number_of_tiles:int, is_set_name:bool) -> void:
    _number_of_tiles = number_of_tiles # Setting the number of tiles value

    # Storing the number of tiles present atm.
    # Counter id acts as number of tiles because
    # remove update happens in next frame so child
    # count is inaccurate
    _tiles_current = _counter_id 
    
    if _number_of_tiles < _tiles_current: # Condition for removing children
        _counter1 = _tiles_current - 1 # Starting from the farthest child
        while _counter1 >= _number_of_tiles: # Loop for removing children
            _remove_tile_input(_counter1)
            _counter1 -= 1
    elif _number_of_tiles > _tiles_current: # Condition for adding children
        _counter1 = 0
        while _counter1 < (_number_of_tiles - _tiles_current): # Loop for adding children
            _add_new_tile_input(is_set_name)
            _counter1 += 1
        
    if !is_set_name: _show_save_msg() # Showing unsaved messageks

## This method removes all the inputs.
func _remove_all_inputs() -> void:
    _counter1 = 0
    while _counter1 < _tile_container.get_child_count(): # Loop for removing all inputs
        _remove_tile_input(_counter1)
        _counter1 += 1
    _counter_id = 0 # Making sure id is resetted to 0

## This method creates a new tile input.
func _add_new_tile_input(is_set_name:bool) -> void:
    _temp = _template_tile_name_ui.instantiate()
    _temp.setup(self, _counter_id) # Setting the tile name UI
    if is_set_name: _temp.setup_name(get_data().get_tile_name(_counter1)) # Setting the name
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
func _show_save_msg() -> void: get_main_ui().show_unsaved_message("Unsaved Chagnes!")