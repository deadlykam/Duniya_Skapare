@tool
extends "res://addons/kamran_wali/duniya_skapare/scripts/stage_generators/ds_base_wfc_gen.gd"

enum WFC_Status {NONE, SETUP, FIND_LOW_ENTROPY_TILE}

# Properties for internal usage ONLY
var _status:= WFC_Status.NONE

# func setup() -> void:
#     super.setup()
#     _status = WFC_Status.FIND_LOW_ENTROPY_TILE

# func _process(delta) -> void:
#     if _status == WFC_Status.FIND_LOW_ENTROPY_TILE:
