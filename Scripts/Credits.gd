extends Node2D

func _ready():
	$BackButton.modulate.a = 0.76

func _on_back_button_pressed():
	SceneManager.changeScene("res://Scenes/MainMenu.tscn")

func _on_back_button_mouse_exited():
	$BackButton.modulate.a = 0.76

func _on_back_button_mouse_entered():
	$BackButton.modulate.a = 0.9