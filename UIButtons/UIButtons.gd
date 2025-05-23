extends Node2D

#Despite being called UI *buttons*, this serves as a more wide use case manager for literally any UI elements that need to be available always

@export var notificationPadding : Vector2

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
## Shows notification that takes [fadeIn] time to come in, stays for [stay] time and leaves in [fadeOut] time
func showNotification(text : String, fadeIn : float = .8, stay : float = .8, fadeOut : float = .8):
	$Notification.text = text
	$Notification/NotificationSprite.scale = $Notification.get_minimum_size()+notificationPadding*2
	#Node doesn't immediately update its size after changing its text, get_minimum_size() is the way to get the size instead	
	$Notification.position.y = -2500#after changing the node's size, it needs to have its position changed once before it takes the new size into account
	$Notification.position = Vector2(1920+notificationPadding.x, 200)
	$Notification/NotificationSprite.position = $Notification.get_minimum_size()/2
	$Notification.show()
	var tween = get_tree().create_tween()
	tween.tween_property($Notification, "position:x", 1920-$Notification.get_minimum_size().x-notificationPadding.x, fadeIn)
	await get_tree().create_timer(fadeIn).timeout
	await get_tree().create_timer(stay).timeout
	tween = get_tree().create_tween()
	tween.tween_property($Notification, "position:x", 1920+notificationPadding.x, fadeOut)
	await get_tree().create_timer(fadeOut).timeout
	$Notification.hide()

func _on_options_pressed():
	$PauseLayer.hide()
	SceneManager.openSettings(false)

func _on_backlog_pressed():
	Backlog.open()		

func _on_menu_pressed() -> void:
	$PauseLayer.hide()
	SceneManager.changeScene("res://Scenes/MainMenu.tscn", 1, 0.7, 2, true)
	if(AudioManager.playingAmbience):
		AudioManager.setAmbienceVolume(0, 0.8)
		await get_tree().create_timer(0.8).timeout
		AudioManager.setAmbiencePlaying(false)

func _on_back_pressed() -> void:
		$PauseLayer.hide()

func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("ui_cancel")):
		if($PauseLayer.visible):
			$PauseLayer.hide()
		elif(pauseMenuEnabled):
			$PauseLayer.show()
			$PauseLayer/AmbienceTrack.text = "Current Music Track: "+AudioManager.currentAmbienceTrack