extends Node

var settings


func load_settings():
	var file_name = "res://settings.tres"
	if ResourceLoader.exists(file_name):
		settings = ResourceLoader.load(file_name)
		if settings is Settings:
			return settings
	else:
		return Settings.new()
		
