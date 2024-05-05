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
var _tiles_current:= 1
var _counter1:= -1
var _dir_counter:= 0
var _temp: Node # Needed for instancing objects

func _enter_tree():
    _tile_container = $Holder/Tile_Container
    _txt_not = $Holder/NOT_Container/Txt_NoT
    _btn_not_ok = $Holder/NOT_Container/Btn_NOT_OK

func _on_btn_not_ok_pressed():
    _number_of_tiles = int(_txt_not.text) # Storing the number of tiles to show.

    if _number_of_tiles < _tiles_current: # Condition for removing children
        _counter1 = _tile_container.get_child_count() - 1 # Starting from the farthest child
        while _counter1 >= _number_of_tiles: # Loop for removing children
            print("Removing children!")
            _tile_container.get_child(_counter1).queue_free() # Removing the child
            _counter1 -= 1
    elif _number_of_tiles > _tiles_current: # Condition for adding children
        _counter1 = 0
        while _counter1 < (_number_of_tiles - _tiles_current): # Loop for adding children
            _temp = _template_tile_name_ui.instantiate()
            # TODO: Get the tile name script and update the id of the script
            _tile_container.add_child(_temp)
            _temp = null
            _counter1 += 1
        
    _tiles_current = _number_of_tiles # Updating current tile numbers

func _on_txt_no_t_text_changed(new_text:String):
    if (new_text.is_valid_int() && new_text != "0" && !new_text.contains("-")
        && !new_text.contains("+")): # Condition for showing the ok button
        _set_font_colour(_txt_not, Color.WHITE)
        _btn_not_ok.visible = true
    else: # Condition for hiding the ok button
        _set_font_colour(_txt_not, Color.RED)
        _btn_not_ok.visible = false
        
## This method sets the font colour for the control.
func _set_font_colour(control:Control, colour:Color) -> void:
    control.add_theme_color_override("font_color", colour)
