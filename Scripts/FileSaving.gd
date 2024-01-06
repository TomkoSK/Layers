extends Resource

class_name Settings

@export var music := 0.5
@export var level := 0.5


func load_settings():
	var file_name = "res://settings.tres"
	if ResourceLoader.exists(file_name):
		var settings = ResourceLoader.load(file_name)
		if settings is Settings:
			return settings
	else:
		return Settings.new()
		
