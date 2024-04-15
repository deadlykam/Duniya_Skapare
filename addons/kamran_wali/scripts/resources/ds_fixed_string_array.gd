@tool
class_name DS_FixedStringArray
extends Resource

@export var _data: Array[String]

## This method updates the given element in the data.
func update_element(element:String, index:int) -> void:
    _data[index] = element

## This method gets an element.
func get_element(index:int) -> String:
    return _data[index]

## This method saves the resource
func save() -> void:
    ResourceSaver.save(self, resource_path, 0)