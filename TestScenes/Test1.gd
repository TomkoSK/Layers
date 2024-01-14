extends Node2D

func _ready():
	UIButtons.set_visibility("ui", true)

func _on_button_pressed():
	SceneManager.changeScene("res://TestScenes/Test2.tscn")
