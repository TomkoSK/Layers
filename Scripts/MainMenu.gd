extends Node2D

var numberedDict
var positions
var currentArrowIndex

#TODO: ADD COMMENTS EXPLAINING THE KEYBOARD CONTROLS PLEASE
func _ready():
	currentArrowIndex = 0
	numberedDict = {0 : $Credits, 1 : $Options, 2 : $Gallery, 3 : $NewGame, 4 : $Continue, 5 : $Quit}
	for value in numberedDict.values():
		value.self_modulate = Color(1, 1, 1, 0.7)
		value.get_child(0).self_modulate = Color(1, 1, 1, 0.75)
	UIButtons.set_visibility("ui", false)#Hides the UI buttons
	var settings = FileManager.load_settings() #Loads the settings from the saved file
	GlobalWorldEnvironment.environment.adjustment_brightness = settings.brightness#This sets the brightness to the settings value
	AudioServer.set_bus_volume_db(1, linear_to_db(settings.music))
	AudioServer.set_bus_volume_db(2, linear_to_db(settings.level))
	if(!MenuMusicPlayer.playingMenuMusic):#Only start the music if it isn't already playing
		MenuMusicPlayer.fadeIn(FileManager.load_settings().music, 1)# smooths out the music volume to start from 0 to the settings.music value in 2 seconds

func showArrow(index):
	numberedDict[currentArrowIndex].get_child(0).hide()
	currentArrowIndex = index
	numberedDict[currentArrowIndex].get_child(0).show()

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

func _on_gallery_pressed():
	SceneManager.changeScene("res://Scenes/Gallery.tscn")

#I assure you this cannot be done in a better way :(
func _on_continue_mouse_entered():
	$Continue.self_modulate = Color(1, 1, 1, 0.9)
	showArrow(numberedDict.find_key($Continue))

func _on_new_game_mouse_entered():
	$NewGame.self_modulate = Color(1, 1, 1, 0.9)
	showArrow(numberedDict.find_key($NewGame))

func _on_options_mouse_entered():
	$Options.self_modulate = Color(1, 1, 1, 0.9)
	showArrow(numberedDict.find_key($Options))

func _on_gallery_mouse_entered():
	$Gallery.self_modulate = Color(1, 1, 1, 0.9)
	showArrow(numberedDict.find_key($Gallery))

func _on_quit_mouse_entered():
	$Quit.self_modulate = Color(1, 1, 1, 0.9)
	showArrow(numberedDict.find_key($Quit))

func _on_credits_mouse_entered():
	$Credits.self_modulate = Color(1, 1, 1, 0.9)
	showArrow(numberedDict.find_key($Credits))


#The same way for the mouse exit, this is the only way I know how to do it
func _on_quit_mouse_exited():
	$Quit.self_modulate = Color(1, 1, 1, 0.7)

func _on_credits_mouse_exited():
	$Credits.self_modulate = Color(1, 1, 1, 0.7)

func _on_gallery_mouse_exited():
	$Gallery.self_modulate = Color(1, 1, 1, 0.7)

func _on_options_mouse_exited():
	$Options.self_modulate = Color(1, 1, 1, 0.7)

func _on_new_game_mouse_exited():
	$NewGame.self_modulate = Color(1, 1, 1, 0.7)

func _on_continue_mouse_exited():
	$Continue.self_modulate = Color(1, 1, 1, 0.7)

func _input(event):
	if(event.is_action_pressed("ui_up")):
		if(currentArrowIndex-1 >= 0):
			showArrow(currentArrowIndex-1)
	if(event.is_action_pressed("ui_down")):
		if(currentArrowIndex+1 <= 5):
			showArrow(currentArrowIndex+1)
	if(event.is_action_pressed("ui_left")):
		if(currentArrowIndex-3 >= 0):
			showArrow(currentArrowIndex-3)
	if(event.is_action_pressed("ui_right")):
		if(currentArrowIndex+3 <= 5):
			showArrow(currentArrowIndex+3)
	if(event.is_action_pressed("ui_accept")):
		numberedDict[currentArrowIndex].emit_signal("pressed")