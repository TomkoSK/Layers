extends Node2D

var focusedDict
var positions
var previousArrow

func _ready():
	previousArrow = $Credits/Arrow
	focusedDict = {$NewGame : false, $Continue : false, $Quit : false, $Credits : false, $Options : false, $Gallery : false}
	positions = {$NewGame : $NewGame.global_position, $Continue : $Continue.global_position, $Quit : $Quit.global_position, $Credits : $Credits.global_position, $Options : $Options.global_position, $Gallery : $Gallery.global_position}
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
	focusedDict[$Continue]= true
	previousArrow.hide()
	$Continue/Arrow.show()
	previousArrow = $Continue/Arrow

func _on_new_game_mouse_entered():
	focusedDict[$NewGame] = true
	previousArrow.hide()
	$NewGame/Arrow.show()
	previousArrow = $NewGame/Arrow

func _on_options_mouse_entered():
	focusedDict[$Options]= true
	previousArrow.hide()
	$Options/Arrow.show()
	previousArrow = $Options/Arrow

func _on_gallery_mouse_entered():
	focusedDict[$Gallery]= true
	previousArrow.hide()
	$Gallery/Arrow.show()
	previousArrow = $Gallery/Arrow


func _on_quit_mouse_entered():
	focusedDict[$Quit]= true
	previousArrow.hide()
	$Quit/Arrow.show()
	previousArrow = $Quit/Arrow


func _on_credits_mouse_entered():
	focusedDict[$Credits]= true
	previousArrow.hide()
	$Credits/Arrow.show()
	previousArrow = $Credits/Arrow
	

#The same way for the mouse exit, this is the only way I know how to do it
func _on_quit_mouse_exited():
	focusedDict[$Quit] = false

func _on_credits_mouse_exited():
	focusedDict[$Credits] = false

func _on_gallery_mouse_exited():
	focusedDict[$Gallery] = false

func _on_options_mouse_exited():
	focusedDict[$Options] = false

func _on_new_game_mouse_exited():
	focusedDict[$NewGame] = false

func _on_continue_mouse_exited():
	focusedDict[$Continue] = false

func _physics_process(delta):
	for key in focusedDict:
		if(focusedDict[key] == true):
			if(key == $NewGame or key == $Continue or key == $Quit):
				key.global_position.x += 180*delta
				key.global_position.x = clamp(key.global_position.x, positions[key].x, positions[key].x+40)
			else:
				key.global_position.x -= 180*delta
				key.global_position.x = clamp(key.global_position.x, positions[key].x-40, positions[key].x)
		else:
			if(key == $NewGame or key == $Continue or key == $Quit):
				key.global_position.x -= 420*delta
				key.global_position.x = clamp(key.global_position.x, positions[key].x, positions[key].x+40)
			else:
				key.global_position.x += 420*delta
				key.global_position.x = clamp(key.global_position.x, positions[key].x-40, positions[key].x)