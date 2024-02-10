extends Node

var previousScene = null
var hoveredDict
var settings
var applyButtonOpacity = 0.55
var settingsBefore = null

func _ready():
	$MenuButton.modulate.a = 0.55
	$ApplyButton.modulate.a = 0.55
	$BackButton.modulate.a = 0.55
	UIButtons.set_visibility("ui", false)
	settings = FileManager.load_settings()
	settingsBefore = Settings.new()
	#I know this is autistic I might put it in a function eventually
	settingsBefore.windowMode = settings.windowMode
	settingsBefore.music = settings.music
	settingsBefore.volume = settings.volume
	settingsBefore.brightness = settings.brightness

	$VBoxContainer/WindowMode/OptionButton.selected = $VBoxContainer/WindowMode/OptionButton.get_item_index(settings.windowMode)
	$VBoxContainer/MusicContainer/HSlider.value = settings.music
	$VBoxContainer/VolumeContainer/HSlider.value = settings.volume
	$VBoxContainer/BrightnessContainer/HSlider.value = settings.brightness

	settingsChanged(false)

func _on_reset_button_pressed():
	settings.windowMode = settingsBefore.windowMode
	settings.music = settingsBefore.music
	settings.volume = settingsBefore.volume
	settings.brightness = settingsBefore.brightness
	$VBoxContainer/WindowMode/OptionButton.selected = $VBoxContainer/WindowMode/OptionButton.get_item_index(settings.windowMode)
	DisplayServer.window_set_mode(settings.windowMode)
	$VBoxContainer/MusicContainer/HSlider.value = settings.music
	AudioServer.set_bus_volume_db(1, linear_to_db(settings.music))
	$VBoxContainer/VolumeContainer/HSlider.value = settings.volume
	AudioServer.set_bus_volume_db(2, linear_to_db(settings.volume))
	$VBoxContainer/BrightnessContainer/HSlider.value = settings.brightness
	GlobalWorldEnvironment.environment.adjustment_brightness = settings.brightness
	settingsChanged(false)

func _on_apply_button_pressed():
	ResourceSaver.save(settings, FileManager.settings_file_name)
	DisplayServer.window_set_mode(settings.windowMode)#Sets the window mode immediately after applying settings
	settingsBefore.windowMode = settings.windowMode
	settingsBefore.music = settings.music
	settingsBefore.volume = settings.volume
	settingsBefore.brightness = settings.brightness
	settingsChanged(false)

func _on_back_button_pressed():
	SceneManager.changeScene(previousScene)

func _on_menu_button_pressed():
	SceneManager.changeScene("res://Scenes/MainMenu.tscn", 1, 0.7, 2, true)
	FileManager.save(previousScene)
	if(AudioManager.playingAmbience):
		AudioManager.setAmbienceVolume(0, 0.8)
		await get_tree().create_timer(0.8).timeout
		AudioManager.setAmbiencePlaying(false)

func _on_window_mode_changed(index:int):
	settingsChanged(true)
	settings.windowMode = $VBoxContainer/WindowMode/OptionButton.get_item_id(index)

func _on_music_slider_changed(value: float):
	settingsChanged(true)
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	settings.music = value

func _on_volume_slider_changed(value: float):
	settingsChanged(true)
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	settings.volume = value

func _on_brightness_changed(value: float):
	settingsChanged(true)
	settings.brightness = value
	GlobalWorldEnvironment.environment.adjustment_brightness = settings.brightness#This sets the brightness to the value that was given

func setMenuButton(visibility : bool):#Called from the SceneManager
	$MenuButton.visible = visibility

func _on_back_button_mouse_entered():
	$BackButton.modulate.a = 0.9

func _on_back_button_mouse_exited():
	$BackButton.modulate.a = 0.55

func _on_menu_button_mouse_entered():
	$MenuButton.modulate.a = 0.9

func _on_menu_button_mouse_exited():
	$MenuButton.modulate.a = 0.55

func _on_apply_button_mouse_entered():
	$ApplyButton.modulate.a = 0.9

func _on_apply_button_mouse_exited():
	$ApplyButton.modulate.a = applyButtonOpacity

func settingsChanged(changed : bool):
	if(changed):
		$ResetButton.show()
		applyButtonOpacity = 0.8
	else:
		$ResetButton.hide()
		applyButtonOpacity = 0.55
	$ApplyButton.modulate.a = applyButtonOpacity