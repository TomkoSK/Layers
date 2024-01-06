extends Node2D

func _on_quit_button_pressed():
	get_tree().quit()

func _on_play_button_pressed():
	SceneManager.changeScene("res://Scenes/PrologueScene.tscn", 1, 0.8, 1)
	MenuMusicPlayer.stopSmooth(1)

func _on_options_button_pressed():
	SceneManager.openSettings()
	

func _on_credits_pressed():
	SceneManager.changeScene("res://Scenes/Credits.tscn", 1, 0.8, 1)
