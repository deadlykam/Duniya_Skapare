@tool
extends Node

@export_category("Generator Simulation Tester")
@export var _generator: DS_BaseGen:
    set(p_generator):
        if _generator != p_generator:
            _generator = p_generator
            update_configuration_warnings()

@export var _counter:= 1:
    set(p_counter):
        if p_counter >= 0:
            if _counter != p_counter:
                _counter = p_counter
                update_configuration_warnings()

@export var _is_print_failed:= false

var _c_success:= 0
var _c_fail:= 0
var _is_show_result:= false

func _get_configuration_warnings():
    var warnings: Array[String]

    if _generator == null:
        warnings.append("Generator: Please provide a generator.")

    return warnings

func _process(delta) -> void:
    if _counter > 0: # Counter to check how many simulation to run
        if !_generator.is_processing(): # Checking if generator processing is done
            if _generator.is_gen_success(): _c_success += 1 # Generator successful
            else: # Generator failed
                if _is_print_failed: print(_generator) # Condition for printing failed generator
                _c_fail += 1

            _generator.reset() # Resetting the generator
            _generator.setup() # Restarting the generation process for the generator
            _counter -= 1
    else: # Simulation ended
        if !_is_show_result: # Condition for showing the results
            print("===Result===")
            print_rich("[color=green]Success: ", _c_success,"[/color], [color=red]Fail:: ", _c_fail,"[/color]")
            print("==XXX==")
            _is_show_result = true