@tool
extends Resource

func save() -> void:
    ResourceSaver.save(self, resource_path, 0)