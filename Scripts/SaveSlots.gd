extends Node2D

var mode : String#the mode in which the scene is operating, if it was reached by clicking the new game button, clicking on an empty
#slot will result in a new game, but if you click on an empty slot after getting to the scene by clicking continue, clicking on an
#empty slot shouldnt do anything, the mode variable distinguishes between those
#it can either be newgame or continue

func _ready():
	#dictionary for converting the scene names into location names that show up in the actual scene
	var scene_location_dict = {"res://TestScenes/Test1.tscn" : "Testing site 1", "res://TestScenes/Test2.tscn" : "Testing site 2"}

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
	on_slot_clicked(1)

func _on_slot_button_2_pressed():
	on_slot_clicked(2)

func _on_slot_button_3_pressed():
	on_slot_clicked(3)

func _on_slot_button_4_pressed():
	on_slot_clicked(4)

func _on_slot_button_5_pressed():
	on_slot_clicked(5)

func on_slot_clicked(slot_number : int):
	var file = FileManager.load_save_file(slot_number)
	if(mode == "continue"):
		if(file.playtime > 0):
			FileManager.set_active_save_file(slot_number)
			SceneManager.changeScene(file.last_scene, 1, 0.8, 1)
			MenuMusicPlayer.fadeOut(1)
	elif(mode == "newgame"):
		if(file.playtime == 0):
			FileManager.set_active_save_file(slot_number)
			SceneManager.changeScene("res://Scenes/PrologueScene.tscn", 1, 0.8, 1)
			MenuMusicPlayer.fadeOut(1)

func format_playtime(seconds : int):
	var string = "%sh %sm"#Just a gdscript format string
	return string % [seconds/3600, (seconds%3600)/60]#Calculates the hours and minutes of playtime (ignore the integer division
	#warning discarding the decimal place is exactly whats useful here since playtime should only have whole numbers)

func _on_menu_button_pressed():
	SceneManager.changeScene("res://Scenes/MainMenu.tscn")