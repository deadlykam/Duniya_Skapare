## This scrit is a singleton that contains all the data needed
## for generating a stage.

class_name DS_Data

static  var _instance: DS_Data # Singleton holder

# Constants
const DS_INT_VAR: GDScript = preload("res://addons/kamran_wali/duniya_skapare/resources/ds_int_var.gd")
const DS_STRING_ARRAY_VAR: GDScript = preload("res://addons/kamran_wali/duniya_skapare/resources/ds_string_array_var.gd")

# Data Properties
var _data_wfc_not: DS_INT_VAR = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse/number_of_tiles.tres")
var _data_wfc_names: DS_STRING_ARRAY_VAR = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse/tile_names.tres")

## This method instansiates the DS_Data singleton.
static func instansiate() -> void:
    if _instance == null:
        _instance = DS_Data.new()

## This method gets the instance of the singleton DS_Data.
static func get_instance() -> DS_Data:
    instansiate()
    return _instance

## This method gets the number of tiles being used in the
## wave function collapse.
func get_wfc_number_of_tiles() -> int:
    return _data_wfc_not.get_value()

## This method gets an array of all the tiles names for the
## wave function collapse.
func get_wfc_tile_names() -> Array[String]:
    return _data_wfc_names.get_data()