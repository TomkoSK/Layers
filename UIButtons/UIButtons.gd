extends Node2D

#Despite being called UI buttons, this serves as a more wide use case manager for literally any UI elements that need to always be available

var pauseMenuEnabled = true

var clockCenter = Vector2(-164, 169)
var clockTime : float = 0#time is a float, so that the clock turns more smoothly when using a tween to change the time's value

func _ready():
	$NotificationGroup.visible = false
	$AnimationPlayer.play("character_menu_show")

func _process(delta):
	var minuteCount = fmod(clockTime,60)
	var hourCount = clockTime/60.0
	print(minuteCount)
	$CharacterMenu/MinuteHand.rotation_degrees = minuteCount*6
	$CharacterMenu/MinuteHand.position = clockCenter+Vector2(48*cos(deg_to_rad(90-minuteCount*6)), -48*sin(deg_to_rad(90-minuteCount*6)))
	$CharacterMenu/HourHand.rotation_degrees = hourCount*30
	$CharacterMenu/HourHand.position = clockCenter+Vector2(40*cos(deg_to_rad(90-hourCount*30)), -40*sin(deg_to_rad(90-hourCount*30)))

func set_clock_time(minutes: int):
	var tween = get_tree().create_tween()

	var duration = 1
	var difference = abs(clockTime-minutes)
	tween.set_trans(Tween.TRANS_SINE)
	if(difference > 120):
		tween.set_trans(Tween.TRANS_CUBIC)
	if(difference > 90):
		duration += log(difference-90)/2.6

	tween.tween_property(self, "clockTime", minutes, duration)

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
