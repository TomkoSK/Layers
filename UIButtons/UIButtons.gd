extends Node2D

#Despite being called UI *buttons*, this serves as a more wide use case manager for literally any UI elements that need to be available always

@export var notificationPadding : Vector2

var pauseMenuEnabled = true

var clockCenter = Vector2(-164, 169)

func _ready():
	$NotificationGroup.visible = false
	await get_tree().create_timer(1.0).timeout
	$AnimationPlayer.play("character_menu_show")

func set_clock_time(minutes: int):
	var minuteCount = minutes%60
	var hourCount = minutes/60
	var tween = get_tree().create_tween()
	tween.tween_property($CharacterMenu/MinuteHand, "rotation_degrees", minuteCount*6, 2)
	tween = get_tree().create_tween()
	tween.tween_property($CharacterMenu/MinuteHand, "position",clockCenter+Vector2(48*cos(deg_to_rad(90-minuteCount*6)), -48*sin(deg_to_rad(90-minuteCount*6))), 2)
	# $CharacterMenu/MinuteHand.rotation_degrees = minuteCount*6
	$CharacterMenu/HourHand.rotation_degrees = hourCount*30
	$CharacterMenu/HourHand.position = clockCenter+Vector2(40*cos(deg_to_rad(90-hourCount*30)), -40*sin(deg_to_rad(90-hourCount*30)))

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
func showNotification(text : String):
	$NotificationGroup/NotificationSprite/Notification.text = text
	$AnimationPlayer.play("notification")
	await $AnimationPlayer.animation_finished
	await get_tree().create_timer(0.5).timeout
	$AnimationPlayer.play("notification_back")
	await $AnimationPlayer.animation_finished
	# $Notification.text = text
	# $Notification/NotificationSprite.scale = $Notification.get_minimum_size()+notificationPadding*2
	# #Node doesn't immediately update its size after changing its text, get_minimum_size() is the way to get the size instead	
	# $Notification.position.y = -2500#after changing the node's size, it needs to have its position changed once before it takes the new size into account
	# $Notification.position = Vector2(1920+notificationPadding.x, 200)
	# $Notification/NotificationSprite.position = $Notification.get_minimum_size()/2
	# $Notification.show()
	# var tween = get_tree().create_tween()
	# tween.tween_property($Notification, "position:x", 1920-$Notification.get_minimum_size().x-notificationPadding.x, fadeIn)
	# await get_tree().create_timer(fadeIn).timeout
	# await get_tree().create_timer(stay).timeout
	# tween = get_tree().create_tween()
	# tween.tween_property($Notification, "position:x", 1920+notificationPadding.x, fadeOut)
	# await get_tree().create_timer(fadeOut).timeout
	# $Notification.hide()

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
