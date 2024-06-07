@tool
extends "res://addons/kamran_wali/duniya_skapare/scripts/stage_generators/wave_function_collapse/ds_wfc_gen_expand.gd"

var _thread: Thread
var _is_stop_thread:= false

func _ready() -> void:
    if !Engine.is_editor_hint(): _thread = Thread.new()
    super()

func setup() -> void:
    if !_thread.is_started(): # Checking if thread has NOT been started
        _is_stop_thread = false # Thread started
        _thread.start(_thread_start_setup) # Starting setup thread

func expand_grid(dir:int) -> void:
    if !_thread.is_started(): # Checking if thread has NOT been started
        _is_stop_thread = false # Thread started
        _thread.start(_thread_start_expand_grid.bind(dir)) # Starting grid expand thread

func is_gen_process() -> bool: return super() or _thread.is_started()

## This method starts the thread setup.
func _thread_start_setup() -> void: super.setup()

## This method starts the grid expand thread.
func _thread_start_expand_grid(dir:int) -> void: super.expand_grid(dir)

## This method stops the thread.
func _thread_stop() -> void: _thread.wait_to_finish()

func _process(delta) -> void:
    if !Engine.is_editor_hint(): # Making sure NOT in editor mode
        if _thread != null: # Checking if the thread has been initialized
            if _thread.is_started(): # Checking if the thread has been started
                if !super.is_gen_process(): # Checking if processing is done
                    if !_is_stop_thread: # Checking if thread is NOT stopped
                        _thread_stop() # Stopping thread
                        _is_stop_thread = true # Thread stopped