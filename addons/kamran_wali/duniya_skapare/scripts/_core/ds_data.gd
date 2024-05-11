## This scrit is a singleton that contains all the data needed
## for generating a stage.

class_name DS_Data

static  var _instance: DS_Data # Singleton holder

# Constants
const DS_WFC_DATA: GDScript = preload("res://addons/kamran_wali/duniya_skapare/resources/ds_wfc_data.gd")

# Data Properties
var _wfc_data: DS_WFC_DATA = load("res://addons/kamran_wali/duniya_skapare/settings/wave_function_collapse/data.tres")

## This method instansiates the DS_Data singleton.
static func instansiate() -> void:
    if _instance == null:
        _instance = DS_Data.new()

## This method gets the instance of the singleton DS_Data.
static func get_instance() -> DS_Data:
    instansiate()
    return _instance

## This method gets the wave function collapse data.
func get_wfc_data() -> DS_WFC_DATA:
    return _wfc_data

## This method sets the new wfc data to be used.
func set_wfc_data(wfc_data:DS_WFC_DATA) -> void:
    _wfc_data = wfc_data