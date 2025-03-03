extends Node2D

var numberedDict
var focusedDict
var positionDict
var scaleDict
var currentArrowIndex

func _ready():
	currentArrowIndex = -1#Index of the button that the arrow is currently pointing at, starts at -1 because the arrow is hidden at the start
	numberedDict = {0 : $Credits, 1 : $Options, 2 : $Gallery, 3 : $NewGame, 4 : $Continue, 5 : $Quit}#Each button is given an index (used with currentArrowIndex)
	#Dictionary with the positions of where the arrow is supposed to go when it goes to a button
	scaleDict = {0 : $Credits.scale, 1 : $Options.scale, 2 : $Gallery.scale, 3 : $NewGame.scale, 4 : $Continue.scale, 5 : $Quit.scale}
	positionDict = {0 : $Credits/Arrow.global_position, 1 : $Options/Arrow.global_position, 2 : $Gallery/Arrow.global_position, 3 : $NewGame/Arrow.global_position, 4 : $Continue/Arrow.global_position, 5 : $Quit/Arrow.global_position}
	for value in numberedDict.values():
		value.self_modulate.a = 0.7#Just sets the initial opacity of the buttons
	UIButtons.set_visibility("ui", false)#Hides the UI buttons

	var settings = FileManager.load_settings() #Loads the settings from the saved file
	GlobalWorldEnvironment.environment.adjustment_brightness = settings.brightness#This sets the brightness to the settings value
	AudioServer.set_bus_volume_db(1, linear_to_db(settings.music))
	AudioServer.set_bus_volume_db(2, linear_to_db(settings.volume))
	$Music.volume_db = -40
	$Music.play()
	var tween = self.create_tween()
	tween.tween_property($Music, "volume_db", 0, 1)
	await get_tree().create_timer(17).timeout
	glitch_effect()

func _on_quit_button_pressed():
	pass

func _on_options_button_pressed():
	pass

func _on_credits_pressed():
	pass

func _on_new_game_pressed():
	pass
	
func _on_continue_pressed():
	pass

func _on_gallery_pressed():
	pass

#moves the arrow to a button when you hover over it with the cursor
func _on_continue_mouse_entered():
	setCurrentArrowIndex(numberedDict.find_key($Continue))#setCurrentArrowIndex() is a custom function

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
	if(currentArrowIndex == -1):#If the index is -1 its being shown for the first time
		$Arrow.position = positionDict[index]#Sets the position instantly
		if(index > 2):
			$Arrow.rotation_degrees = 0
			$Arrow.position.x -= 400#Makes the button come in smoothly by offsetting the position by 400 pixels
		else:
			$Arrow.rotation_degrees = -180
			$Arrow.position.x += 400
		$Arrow.visible = true
	currentArrowIndex = index

func _input(event):#Handles the keyboard controls of the arrow
	if(event.is_action_pressed("ui_cancel")):
		glitch_effect()
	if(currentArrowIndex == -1):#If arrow wasn't shown yet it sets the index based on which arrow was pressed
		if(event.is_action_pressed("ui_up")):
			setCurrentArrowIndex(0)
			return
		if(event.is_action_pressed("ui_down")):
			setCurrentArrowIndex(2)
			return
		if(event.is_action_pressed("ui_left")):
			setCurrentArrowIndex(1)
			return
		if(event.is_action_pressed("ui_right")):
			setCurrentArrowIndex(4)
			return
	#The buttons are numbered 0-5, so when you decrease the index by 1 you go to the button that's 1 position higher, if u increase it u go 1 button lower
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
	if(event.is_action_pressed("ui_accept")):#Pressing enter on an active button presses the button as if it was clicked
		if(currentArrowIndex != -1):
			numberedDict[currentArrowIndex].emit_signal("pressed")

func setShake(shakeValue):
	$GlitchSprite.material.set_shader_parameter("shake_power", shakeValue)

func glitch_effect():
	var tween = self.create_tween()
	tween.tween_property($Music, "volume_db", -40, 3)
	tween.tween_callback($Music.stop)
	await get_tree().create_timer(2.0).timeout
	$GlitchSprite.show()
	$GlitchAudio.play()
	$StaticAudio.play()
	$GlitchAudio.volume_db = -10
	await get_tree().create_timer(0.3).timeout
	$GlitchSprite.hide()
	$GlitchAudio.stop()
	$StaticAudio.stop()
	await get_tree().create_timer(1).timeout
	$GlitchSprite.show()
	$GlitchAudio.play()
	$StaticAudio.play()
	tween = self.create_tween()
	tween.set_trans(Tween.TransitionType.TRANS_QUINT)
	tween.tween_method(setShake, 0.015, 0.08, 1.3)
	$GlitchAudio.volume_db = -10
	tween = self.create_tween()
	tween.set_trans(Tween.TransitionType.TRANS_LINEAR)
	tween.tween_property($GlitchAudio, "volume_db", 5, 3.3)
	await get_tree().create_timer(1.3).timeout
	await RenderingServer.frame_post_draw
	var texture = get_viewport().get_texture()
	var imgtex = ImageTexture.create_from_image(texture.get_image())
	SceneManager.setBackgroundTexture(imgtex)
	$GlitchSprite.hide()
	for button in numberedDict.values():
		button.hide()
	$Arrow.hide()
	$VideoStreamPlayer.hide()
	await get_tree().create_timer(2).timeout
	$GlitchAudio.stop()
	$StaticAudio.stop()
	SceneManager.setBackgroundFromPath("res://Textures/glitchBG.png")
	await get_tree().create_timer(1).timeout
	$MorseCode.play()
	await $MorseCode.finished
	await get_tree().create_timer(0.5).timeout
	$GlitchSprite.show()
	$GlitchAudio.play()
	$StaticAudio.play()
	await get_tree().create_timer(0.2).timeout
	SceneManager.changeScene("res://Scenes/MainMenu.tscn", 0, 0, 0)


func _process(delta):#The actual movement of the arrow happens here
	if(currentArrowIndex > -1):#If the arrow wasnt shown yet no need to move it
		var speed = 8*delta*$Arrow.position.distance_to(positionDict[currentArrowIndex])
		#The arrow's speed gets smaller the closer its distance to the button is (it feels smooth)
		$Arrow.position = $Arrow.position.move_toward(positionDict[currentArrowIndex], speed)
		if(currentArrowIndex < 3):#With the left buttons, the arrow has to point in a different direction so its rotated smoothly
			#Button indexes 0 1 and 2 are the left buttons
			$Arrow.rotation_degrees -= 1.482*delta*$Arrow.position.distance_to(positionDict[currentArrowIndex])
			#1.482 was acquired through manual testing :3
			#The arrow also rotates more slowly as it gets closer to the button, its smoother
		else:
			$Arrow.rotation_degrees += 1.482*delta*$Arrow.position.distance_to(positionDict[currentArrowIndex])
		$Arrow.rotation_degrees = clamp($Arrow.rotation_degrees, -180, 0)#Clamps the rotation so that it doesnt rotate too far
		
		for key in numberedDict:#When you select a button, the opacity is increased, thats done here (its done smoothly)
			if(key == currentArrowIndex):
				numberedDict[key].self_modulate.a += 0.65 * delta
				numberedDict[key].scale += scaleDict[key]*0.19*delta
			else:
				numberedDict[key].self_modulate.a -= 0.65 * delta
				numberedDict[key].scale -= scaleDict[key]*0.19*delta
			numberedDict[key].self_modulate.a = clamp(numberedDict[key].self_modulate.a, 0.7, 0.9)#when button isnt selected the opacity is 0.7, when it is the opacity is 0.9
			numberedDict[key].scale = clamp(numberedDict[key].scale,  scaleDict[key], scaleDict[key]*1.04)
