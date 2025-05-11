extends Node2D

var pauseMenuEnabled = true

func set_visibility(buttonName : String, setVisible : bool):
	if(buttonName == "ui"):
		if(setVisible):
			pauseMenuEnabled = true
			$Backlog.show()
		else:
			pauseMenuEnabled = false
			$Backlog.hide()
	elif(buttonName == "pausemenu"):
		if(setVisible):
			pauseMenuEnabled = true
		else:
			pauseMenuEnabled = false
	elif(buttonName == "backlog"):
		if(setVisible):
			$Backlog.show()
		else:
			$Backlog.hide()
	else:
		print("[WARNING]",buttonName," was passed into ui buttons set visibility function")

func _on_options_pressed():
	$CanvasLayer.hide()
	SceneManager.openSettings(false)

func _on_backlog_pressed():
	Backlog.open()		

func _on_menu_pressed() -> void:
	$CanvasLayer.hide()
	SceneManager.changeScene("res://Scenes/MainMenu.tscn", 1, 0.7, 2, true)
	if(AudioManager.playingAmbience):
		AudioManager.setAmbienceVolume(0, 0.8)
		await get_tree().create_timer(0.8).timeout
		AudioManager.setAmbiencePlaying(false)

func _on_back_pressed() -> void:
		$CanvasLayer.hide()

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_cancel")):
		if($CanvasLayer.visible):
			$CanvasLayer.hide()
		elif(pauseMenuEnabled):
			$CanvasLayer.show()
			$CanvasLayer/AmbienceTrack.text = "Current Music Track: "+AudioManager.currentAmbienceTrack