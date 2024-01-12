extends Node2D

func _ready():
	self.z_index = 2

func set_visibility(buttonName : String, setVisible : bool):
	if(buttonName == "ui"):
		if(setVisible):
			self.show()
		else:
			self.hide()
	elif(buttonName == "options"):
		if(setVisible):
			$Options.show()
		else:
			$Options.hide()
	elif(buttonName == "backlog"):
		if(setVisible):
			$Backlog.show()
		else:
			$Backlog.hide()
	elif(buttonName == "main_menu"):
		if(setVisible):
			$MainMenu.show()
		else:
			$MainMenu.hide()
	else:
		print("[WARNING]",buttonName," was passed into ui buttons set visibility function")

func _on_options_pressed():
	SceneManager.openSettings()

func _on_main_menu_pressed():
	SceneManager.changeScene("res://Scenes/MainMenu.tscn")

func _on_backlog_pressed():
	Backlog.show()		
