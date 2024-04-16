@tool
extends Resource

## This method saves the resource
func save() -> void:
    ResourceSaver.save(self, resource_path, 0)