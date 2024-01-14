extends Node2D

func _ready():
	UIButtons.set_visibility("ui", false)#Hides the UI buttons
	var settings = FileManager.load_settings() #Loads the settings from the saved file
	GlobalWorldEnvironment.environment.adjustment_brightness = settings.brightness#This sets the brightness to the settings value
	AudioServer.set_bus_volume_db(1, linear_to_db(settings.music))
	AudioServer.set_bus_volume_db(2, linear_to_db(settings.level))
	MenuMusicPlayer.fadeIn(FileManager.load_settings().music, 2)# smooths out the music volume to start from 0 to the settings.music value in 2 seconds

func _on_quit_button_pressed():
	get_tree().quit()

func _on_options_button_pressed():
	SceneManager.openSettings()

func _on_credits_pressed():
	SceneManager.changeScene("res://Scenes/Credits.tscn", 1, 0.8, 1)

func _on_new_game_pressed():
	SceneManager.openSaveSlots("newgame")
	
func _on_continue_pressed():
	SceneManager.openSaveSlots("continue")
