extends Node

var previousScene = null
var hoveredDict
var settings

func _ready():
	$MenuButton.modulate.a = 0.55
	$ApplyButton.modulate.a = 0.55
	$BackButton.modulate.a = 0.55
	UIButtons.set_visibility("ui", false)
	settings = FileManager.load_settings()
	var windowMode = DisplayServer.window_get_mode()
	if(windowMode == 0 or windowMode == 1 or windowMode == 2):#All the windowed modes
		$VBoxContainer/WindowMode/OptionButton.selected = 1#windowed index
	else:
		$VBoxContainer/WindowMode/OptionButton.selected = 0
	$VBoxContainer/MusicContainer/HSlider.value = settings.music
	$VBoxContainer/VolumeContainer/HSlider.value = settings.volume
	$VBoxContainer/BrightnessContainer/HSlider.value = settings.brightness
	
func _on_apply_button_pressed():
	ProjectSettings.save()
	ResourceSaver.save(settings, FileManager.settings_file_name)
	DisplayServer.window_set_mode(ProjectSettings.get_setting("display/window/size/mode"))#Sets the window mode immediately after applying settings
	
func _on_back_button_pressed():
	SceneManager.changeScene(previousScene)

func _on_menu_button_pressed():
	SceneManager.changeScene("res://Scenes/MainMenu.tscn", 0.6, 0.4, 0.6)
	if(AudioManager.playingAmbience):
		AudioManager.stopAmbience(1)

func _on_window_mode_changed(index:int):
	ProjectSettings.set_setting("display/window/size/mode", $VBoxContainer/WindowMode/OptionButton.get_item_id(index))

func _on_music_slider_changed(value: float):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	settings.music = value

func _on_volume_slider_changed(value: float):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	settings.volume = value

func _on_brightness_changed(value: float):
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
	$ApplyButton.modulate.a = 0.55
