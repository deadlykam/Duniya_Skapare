@tool
extends "res://addons/kamran_wali/duniya_skapare/scripts/stage_generators/wave_function_collapse/ds_wfc_gen.gd"

var _thread: Thread
var _is_stop_thread:= false

func _ready() -> void:
    if !Engine.is_editor_hint(): _thread = Thread.new()
    super()

func setup() -> void:
    if !_thread.is_started(): # Checking if thread is NOT alive
        _is_stop_thread = false # Restting flag for future checks
        _thread.start(_thread_start) # Starting thread

func is_gen_process() -> bool: return super() or _thread.is_started()

## This method starts the thread.
func _thread_start() -> void: super.setup()

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