extends Node2D

var focusedDict
var numberedDict
var positions
var previousArrow

func _ready():
	previousArrow = $Credits/Arrow
	numberedDict = {0 : $Credits, 1 : $Options, 2 : $Gallery, 3 : $NewGame, 4 : $Continue, 5 : $Quit}
	focusedDict = {$NewGame : false, $Continue : false, $Quit : false, $Credits : false, $Options : false, $Gallery : false}
	for key in focusedDict:
		key.self_modulate = Color(1, 1, 1, 0.7)
		key.get_child(0).self_modulate = Color(1, 1, 1, 0.75)
	UIButtons.set_visibility("ui", false)#Hides the UI buttons
	var settings = FileManager.load_settings() #Loads the settings from the saved file
	GlobalWorldEnvironment.environment.adjustment_brightness = settings.brightness#This sets the brightness to the settings value
	AudioServer.set_bus_volume_db(1, linear_to_db(settings.music))
	AudioServer.set_bus_volume_db(2, linear_to_db(settings.level))
	if(!MenuMusicPlayer.playingMenuMusic):#Only start the music if it isn't already playing
		MenuMusicPlayer.fadeIn(FileManager.load_settings().music, 1)# smooths out the music volume to start from 0 to the settings.music value in 2 seconds

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

#I assure you this cannot be done in a better way :(
func _on_continue_mouse_entered():
	$Continue.self_modulate = Color(1, 1, 1, 0.9)
	previousArrow.hide()
	$Continue/Arrow.show()
	previousArrow = $Continue/Arrow

func _on_new_game_mouse_entered():
	$NewGame.self_modulate = Color(1, 1, 1, 0.9)
	previousArrow.hide()
	$NewGame/Arrow.show()
	previousArrow = $NewGame/Arrow

func _on_options_mouse_entered():
	$Options.self_modulate = Color(1, 1, 1, 0.9)
	previousArrow.hide()
	$Options/Arrow.show()
	previousArrow = $Options/Arrow

func _on_gallery_mouse_entered():
	$Gallery.self_modulate = Color(1, 1, 1, 0.9)
	previousArrow.hide()
	$Gallery/Arrow.show()
	previousArrow = $Gallery/Arrow

func _on_quit_mouse_entered():
	$Quit.self_modulate = Color(1, 1, 1, 0.9)
	previousArrow.hide()
	$Quit/Arrow.show()
	previousArrow = $Quit/Arrow

func _on_credits_mouse_entered():
	$Credits.self_modulate = Color(1, 1, 1, 0.9)
	previousArrow.hide()
	$Credits/Arrow.show()
	previousArrow = $Credits/Arrow


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
