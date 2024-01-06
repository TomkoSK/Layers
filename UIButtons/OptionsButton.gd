extends Node2D

var scenesToHideButtonIn
var hiding = true

func _ready():
	self.hide()#button starts hidden since the game starts on the main menu
	scenesToHideButtonIn = ["res://BlackScene.tscn", "res://Scenes/Backlog.tscn", "res://Scenes/MainMenu.tscn", "res://Scenes/Settings.tscn", "res://Scenes/PrologueScene.tscn"]
	self.z_index = 2
	$Timer.start()

func _on_button_pressed():
	SceneManager.openSettings()


func _on_timer_timeout():
	var scene = get_tree().current_scene
	if(scene != null):#happens when switching scenes
		if(hiding):
			if(!scenesToHideButtonIn.has(scene.scene_file_path)):
				self.show()
				hiding = false
		if(!hiding):
			if(scenesToHideButtonIn.has(scene.scene_file_path)):
				self.hide()
				hiding = true
