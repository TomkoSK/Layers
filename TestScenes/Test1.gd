extends Node2D

func _ready():
	FileManager.set_active_save_file(1)
	FileManager.set_time(FileManager.get_time())

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("test")):
		FileManager.set_time(FileManager.get_time()+10)