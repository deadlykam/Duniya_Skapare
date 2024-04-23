## This script is a singleton that contains all the data needed
## for generating a stage

class_name DS_Data

static var _instance: DS_Data # Singleton holder

# Constants
const DS_FIXEDSTRINGARRAY: GDScript = preload("res://addons/kamran_wali/duniya_skapare/scripts/resources/ds_fixed_string_array.gd")
const DS_FIXEDCHECKBOXFLAGARRAY: GDScript = preload("res://addons/kamran_wali/duniya_skapare/scripts/resources/ds_fixed_checkbox_flag_array.gd")
const DATA_NOO: GDScript = preload("res://addons/kamran_wali/duniya_skapare/scripts/resources/ds_noo.gd")
const DATA_TILE_RULE: GDScript = preload("res://addons/kamran_wali/duniya_skapare/scripts/resources/ds_tile_rules.gd")

# Data Properties
var _data_wfc_names: DS_FIXEDSTRINGARRAY = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse_settings/data_names.tres")
var _data_wfc_rules: DS_FIXEDCHECKBOXFLAGARRAY = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse_settings/data_rules.tres")
var _data_wfc_noo: DATA_NOO = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse_settings/data_noo.tres")
var _data_wfc_rules_individual: DATA_TILE_RULE = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse_settings/data_rules_individual.tres")

var _wfc_names: Array[String]
var _wfc_rules: Array[bool]
var _temp_tile_rules: Array[int] # Individual tile rules

var _counter1 := -1

## This method instansiates the DS_Data singleton.
static func instansiate() -> void:
    if _instance == null:
        _instance = DS_Data.new()
        _instance._convert_data()

## This method gets the instance of the singleton DS_Data.
static func get_instance() -> DS_Data:
    instansiate()
    return _instance

## This method gets an array of tile names for the
## wave function collapse.
func get_wfc_tile_names() -> Array[String]:
    return _wfc_names

## This method gets an array of tile rules for the
## wave function collapse.
func get_wfc_rules() -> Array[bool]:
    return _wfc_rules

## This method gets the number of tiles being used
## in the wave function collapse.
func get_wfc_number_of_tiles() -> int:
    return _data_wfc_noo.get_value()

## This method gets an array of rules for the given individual tile.
## This is recommended to store the array in a variable as calling
## this over and over will become very expensive for performance.
func get_wfc_tile_rules(tile:int) -> Array[int]:
    _temp_tile_rules.clear()
    _counter1 = 0 # The counter is the position index
    while _counter1 <= tile: # Loop for finding rules
        if _data_wfc_rules.get_element(tile, _counter1):
            _temp_tile_rules.append(_counter1) # Adding rule
        _counter1 += 1
    
    # Setting the next tile for check.
    # Also _counter1 is now the main tile.
    _counter1 = tile + 1
    while _counter1 <= _data_wfc_noo.get_value(): # Loop for finding rules
        if _data_wfc_rules.get_element(_counter1, tile): # Conditionf for rule found
            _temp_tile_rules.append(_counter1) # Adding the rule
        _counter1 += 1

    return _temp_tile_rules

## This method gets the name of the wfc tile.
func get_wfc_tile_name(tile:int) -> String:
    return _data_wfc_names.get_element(tile)

## This method converts the data to user readable data.
func _convert_data() -> void:
    _wfc_names = _data_wfc_names.get_data()
    _wfc_rules = _data_wfc_rules.get_data()