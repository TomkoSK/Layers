extends Node2D

var borderLocation = Vector2(864, 112+213*2)#Current location of the border

var normal = 74#Parameters for the flashing of the border when a save slot is clicked
var flashed = 225
var flashSpeed = 18.0#do NOT forget the decimal place if changing the speed, having it as an integer leads to integer division in the code

var mode : String#the mode in which the scene is operating, if it was reached by clicking the new game button, clicking on an empty
#slot will result in a new game, but if you click on an empty slot after getting to the scene by clicking continue, clicking on an
#empty slot shouldnt do anything, the mode variable distinguishes between those
#it can either be newgame or continue

func _ready():
	#dictionary for converting the scene names into location names that show up in the actual scene
	var scene_location_dict = {"res://TestScenes/Test1.tscn" : "Testing site 1", "res://TestScenes/Test2.tscn" : "Testing site 2", "res://Scenes/PrologueScene.tscn" : "Prologue Scene"}

	var slot1 = FileManager.load_save_file(1)
	if(slot1.playtime > 0):#0 playtime means the save slot has not been taken up at all so the playtime and location arent displayed
		$Label1.text += "\nPLAYTIME: %s\nLOCATION: %s" % [format_playtime(slot1.playtime), scene_location_dict[slot1.last_scene]]#Adds playtime and the location to the slot text
	
	var slot2 = FileManager.load_save_file(2)
	if(slot2.playtime > 0):
		$Label2.text += "\nPLAYTIME: %s\nLOCATION: %s" % [format_playtime(slot2.playtime), scene_location_dict[slot2.last_scene]]
	
	var slot3 = FileManager.load_save_file(3)
	if(slot3.playtime > 0):
		$Label3.text += "\nPLAYTIME: %s\nLOCATION: %s" % [format_playtime(slot3.playtime), scene_location_dict[slot3.last_scene]]
	
	var slot4 = FileManager.load_save_file(4)
	if(slot4.playtime > 0):
		$Label4.text += "\nPLAYTIME: %s\nLOCATION: %s" % [format_playtime(slot4.playtime), scene_location_dict[slot4.last_scene]]
	
	var slot5 = FileManager.load_save_file(5)
	if(slot5.playtime > 0):
		$Label5.text += "\nPLAYTIME: %s\nLOCATION: %s" % [format_playtime(slot5.playtime), scene_location_dict[slot5.last_scene]]
	#No way to do this through a for loop or something like that because of the $Label thing so we're stuck with this code

	UIButtons.set_visibility("ui", false)

func _on_slot_button_1_pressed():
	borderLocation.y = 112
	$SlotButton1.release_focus()#the button grabbing the focus when clicked messes up the keyboard controls
	on_slot_clicked(1)

func _on_slot_button_2_pressed():
	borderLocation.y = 112+213*1
	$SlotButton2.release_focus()
	on_slot_clicked(2)

func _on_slot_button_3_pressed():
	borderLocation.y = 112+213*2
	$SlotButton3.release_focus()
	on_slot_clicked(3)

func _on_slot_button_4_pressed():
	borderLocation.y = 112+213*3
	$SlotButton4.release_focus()
	on_slot_clicked(4)

func _on_slot_button_5_pressed():
	borderLocation.y = 112+213*4
	$SlotButton5.release_focus()
	on_slot_clicked(5)

func _on_slot_button_1_mouse_entered():
	borderLocation.y = 112

func _on_slot_button_2_mouse_entered():
	borderLocation.y = 112+213

func _on_slot_button_3_mouse_entered():
	borderLocation.y = 112+213*2

func _on_slot_button_4_mouse_entered():
	borderLocation.y = 112+213*3

func _on_slot_button_5_mouse_entered():
	borderLocation.y = 112+213*4

func on_slot_clicked(slot_number : int):
	flash()
	var file = FileManager.load_save_file(slot_number)
	if(mode == "continue"):
		if(file.playtime > 0):
			FileManager.set_active_save_file(slot_number)
			SceneManager.changeScene(file.last_scene, 1, 0.8, 1)
			AudioManager.setMenuMusicVolume(0, 1)
			await get_tree().create_timer(1).timeout
			AudioManager.setMenuMusicPlaying(false)
			Input.set_custom_mouse_cursor(load("res://Textures/cursor65res.png"))
	elif(mode == "newgame"):
		if(file.playtime == 0):
			FileManager.set_active_save_file(slot_number)
			SceneManager.changeScene("res://GameplayScenes/PrologueScene.tscn", 1, 0.8, 1)
			AudioManager.setMenuMusicVolume(0, 1)
			await get_tree().create_timer(1).timeout
			AudioManager.setMenuMusicPlaying(false)
			Input.set_custom_mouse_cursor(load("res://Textures/cursor65res.png"))

func format_playtime(seconds : int):
	var string = "%sh %sm"#Just a gdscript format string
	return string % [seconds/3600, (seconds%3600)/60]#Calculates the hours and minutes of playtime (ignore the integer division
	#warning discarding the decimal place is exactly whats useful here since playtime should only have whole numbers)

func _on_menu_button_pressed():
	SceneManager.changeScene("res://Scenes/MainMenu.tscn")

func _input(event):
	if(event.is_action_pressed("ui_down")):#moves the border using keyboard controls
		borderLocation.y += 213
		borderLocation.y = clamp(borderLocation.y, 112, 112+213*4)#makes sure the border isn't offscreen
	if(event.is_action_pressed("ui_up")):
		borderLocation.y -= 213
		borderLocation.y = clamp(borderLocation.y, 112, 112+213*4)
	if(event.is_action_pressed("ui_accept")):
		on_slot_clicked((borderLocation.y-112)/213+1)#Clicks the slot that the border is currently on
	if(event.is_action_pressed("ui_cancel")):
		$MenuButton.emit_signal("pressed")

func _process(delta):
	var speed = 12*delta*$Border.position.distance_to(borderLocation)
	$Border.position = $Border.position.move_toward(borderLocation, speed)

func flash():#flashes the border to white and back, called when a save slot is clicked
	for i in range(abs(normal-flashed)/flashSpeed):
		$Border.self_modulate.g += flashSpeed/255
		$Border.self_modulate.b += flashSpeed/255
		await get_tree().create_timer(0.005).timeout
	for i in range(abs(normal-flashed)/flashSpeed):
		$Border.self_modulate.g -= flashSpeed/255
		$Border.self_modulate.b -= flashSpeed/255
		await get_tree().create_timer(0.005).timeout
