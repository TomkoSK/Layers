extends Node2D

var numberedDict
var focusedDict
var positionDict
var currentArrowIndex

#TODO: ADD COMMENTS EXPLAINING EVERYTHING PLEASE
func _ready():
	currentArrowIndex = -1
	numberedDict = {0 : $Credits, 1 : $Options, 2 : $Gallery, 3 : $NewGame, 4 : $Continue, 5 : $Quit}
	positionDict = {0 : $Credits/Arrow.global_position, 1 : $Options/Arrow.global_position, 2 : $Gallery/Arrow.global_position, 3 : $NewGame/Arrow.global_position, 4 : $Continue/Arrow.global_position, 5 : $Quit/Arrow.global_position}
	for value in numberedDict.values():
		value.self_modulate = Color(1, 1, 1, 0.7)
		value.get_child(0).self_modulate = Color(1, 1, 1, 0.5)
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
	SceneManager.openSettings(true)

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
	setCurrentArrowIndex(numberedDict.find_key($Continue))

func _on_new_game_mouse_entered():
	setCurrentArrowIndex(numberedDict.find_key($NewGame))

func _on_options_mouse_entered():
	setCurrentArrowIndex(numberedDict.find_key($Options))

func _on_gallery_mouse_entered():
	setCurrentArrowIndex(numberedDict.find_key($Gallery))

func _on_quit_mouse_entered():
	setCurrentArrowIndex(numberedDict.find_key($Quit))

func _on_credits_mouse_entered():
	setCurrentArrowIndex(numberedDict.find_key($Credits))

func setCurrentArrowIndex(index):
	if(currentArrowIndex == -1):
		$Arrow.position = positionDict[index]
		if(index > 2):
			$Arrow.rotation_degrees = 0
			$Arrow.position.x -= 400
		else:
			$Arrow.rotation_degrees = -180
			$Arrow.position.x += 400
		$Arrow.visible = true
	currentArrowIndex = index

func _input(event):
	if(currentArrowIndex == -1):
		if(event.is_action_pressed("ui_up")):
			setCurrentArrowIndex(0)
		if(event.is_action_pressed("ui_down")):
			setCurrentArrowIndex(2)
		if(event.is_action_pressed("ui_left")):
			setCurrentArrowIndex(1)
		if(event.is_action_pressed("ui_right")):
			setCurrentArrowIndex(4)
	if(event.is_action_pressed("ui_up")):
		if(currentArrowIndex-1 >= 0):
			setCurrentArrowIndex(currentArrowIndex - 1)
	if(event.is_action_pressed("ui_down")):
		if(currentArrowIndex+1 <= 5):
			setCurrentArrowIndex(currentArrowIndex + 1)
	if(event.is_action_pressed("ui_left")):
		if(currentArrowIndex-3 >= 0):
			setCurrentArrowIndex(currentArrowIndex - 3)
	if(event.is_action_pressed("ui_right")):
		if(currentArrowIndex+3 <= 5):
			setCurrentArrowIndex(currentArrowIndex + 3)
	if(event.is_action_pressed("ui_accept")):
		numberedDict[currentArrowIndex].emit_signal("pressed")

func _process(delta):
	if(currentArrowIndex > -1):
		$Arrow.position = $Arrow.position.move_toward(positionDict[currentArrowIndex], 2000*delta*$Arrow.position.distance_to(positionDict[currentArrowIndex])*0.004)
		if(currentArrowIndex < 3):
			$Arrow.rotation_degrees -= 600*delta*$Arrow.position.distance_to(positionDict[currentArrowIndex])*0.00247
		else:
			$Arrow.rotation_degrees += 600*delta*$Arrow.position.distance_to(positionDict[currentArrowIndex])*0.00247
		$Arrow.rotation_degrees = clamp($Arrow.rotation_degrees, -180, 0)
		for key in numberedDict:
			if(key == currentArrowIndex):
				numberedDict[key].self_modulate.a += 0.7 * delta
			else:
				numberedDict[key].self_modulate.a -= 0.7 * delta
			numberedDict[key].self_modulate.a = clamp(numberedDict[key].self_modulate.a, 0.7, 0.9)
