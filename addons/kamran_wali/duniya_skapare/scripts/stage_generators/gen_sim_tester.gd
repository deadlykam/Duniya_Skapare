@tool
extends Node

@export_category("Generator Simulation Tester")
@export var _generator: DS_BaseGen:
	set(p_generator):
		if _generator != p_generator:
			_generator = p_generator
			update_configuration_warnings()

@export var _number_of_simulations:= 1:
	set(p_number_of_simulations):
		if p_number_of_simulations >= 0:
			if _number_of_simulations != p_number_of_simulations:
				_number_of_simulations = p_number_of_simulations
				update_configuration_warnings()

## Press the "UP" arrow key in the keyboard to print data of the
## current Generator running. Will ONLY work with threaded
## Generators.
@export var _enable_manual_print:= false

@export var _is_print_success:= false
@export var _is_print_failed:= false
@export var _is_print_final:= false

var _counter:= -1
var _c_success:= 0
var _c_fail:= 0
var _is_show_result:= false
var _avg_process_time:= 0.0
var _avg_process_loop:= 0
var _check_start_setup:= false

func _get_configuration_warnings():
	var warnings: Array[String]

	if _generator == null:
		warnings.append("Generator: Please provide a generator.")

	return warnings

func _ready() -> void:
	_counter = _number_of_simulations
	_check_start_setup = false

func _process(delta) -> void:
	if !Engine.is_editor_hint(): # Play Mode
		if !_check_start_setup: # Condition for checking if start setup is enabled or disabled
			if !_generator.is_start_setup(): _generator.setup() # Condition for calling generator setup
			_check_start_setup = true
		
		if _counter > 0: # Counter to check how many simulation to run
			if !_generator.is_gen_process(): # Checking if generator processing is done
				if _generator.is_gen_success():
					if _is_print_success: print(_generator) # Condition for printing successful generator
					_c_success += 1 # Generator successful
				else: # Generator failed
					if _is_print_failed: print(_generator) # Condition for printing failed generator
					_c_fail += 1

				_avg_process_time += _generator.get_run_time() # Adding the run times
				_avg_process_loop += _generator.get_process_loop() # Adding the process loop
				_counter -= 1
				if _counter > 0: # Condition to run the simulation again
					_generator.reset() # Resetting the generator
					_generator.setup() # Restarting the generation process for the generator
		else: # Simulation ended
			if !_is_show_result: # Condition for showing the results
				_print_result()
				_is_show_result = true
		
		if _enable_manual_print: # Condition for printing the current processing generator
			if Input.is_action_just_pressed("ui_up"): # Prints the current processing generator
				_generator.print_debug_info() # Printing current processing generator

## This method prints the result.
func _print_result() -> void:
	print_rich("[rainbow sat=0.5]===Generator Simulation Result===[/rainbow]")
	print_rich("[color=green]Success: ", _c_success,"[/color], [color=red]Fail: ", _c_fail, "[/color]", 
		", Success Rate: ", ((float(_c_success) / float(_number_of_simulations)) * 100), "%")
	if _number_of_simulations > 0:
		print_rich("[color=orange]Average Run Time: ", (_avg_process_time / _number_of_simulations), "ms[/color]")
		print_rich("Average Process Loop: ", (float(_avg_process_loop) / float(_number_of_simulations)))
	if _is_print_final: print(_generator)
	print_rich("[rainbow sat=0.5]===XXX===[/rainbow]")
