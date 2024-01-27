extends Node

var previousScene = null
var hoveredDict
var settings

func _ready():
	hoveredDict = {$BackButton : false, $MenuButton : false, $ApplyButton : false}
	UIButtons.set_visibility("ui", false)
	settings = FileManager.load_settings()
	var windowMode = DisplayServer.window_get_mode()
	if(windowMode == 0 or windowMode == 1 or windowMode == 2):#All the windowed modes
		$VBoxContainer/WindowMode/OptionButton.selected = 1#windowed index
	else:
		$VBoxContainer/WindowMode/OptionButton.selected = 0
	$VBoxContainer/MusicContainer/HSlider.value = settings.music
	$VBoxContainer/VolumeContainer/HSlider.value = settings.level
	$VBoxContainer/BrightnessContainer/HSlider.value = settings.brightness
	
func _on_apply_button_pressed():
	ProjectSettings.save()
	ResourceSaver.save(settings, FileManager.settings_file_name)
	DisplayServer.window_set_mode(ProjectSettings.get_setting("display/window/size/mode"))#Sets the window mode immediately after applying settings
	
func _on_window_mode_changed(index:int):
	ProjectSettings.set_setting("display/window/size/mode", $VBoxContainer/WindowMode/OptionButton.get_item_id(index))

func _on_back_button_pressed():
	SceneManager.changeScene(previousScene)

func _on_music_slider_changed(value: float):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	settings.music = value

func _on_volume_slider_changed(value: float):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	settings.level = value

func _on_brightness_changed(value: float):
	settings.brightness = value
	GlobalWorldEnvironment.environment.adjustment_brightness = settings.brightness#This sets the brightness to the value that was given

func setMenuButton(visibility : bool):#Called from the SceneManager
	$MenuButton.visible = visibility

func _on_menu_button_pressed():
	SceneManager.changeScene("res://Scenes/MainMenu.tscn")

func _on_back_button_mouse_entered():
	hoveredDict[$BackButton] = true

func _on_back_button_mouse_exited():
	hoveredDict[$BackButton] = false

func _on_menu_button_mouse_entered():
	hoveredDict[$MenuButton] = true

func _on_menu_button_mouse_exited():
	hoveredDict[$MenuButton] = false

func _on_apply_button_mouse_entered():
	hoveredDict[$ApplyButton] = true

func _on_apply_button_mouse_exited():
	hoveredDict[$ApplyButton] = false
	
func _process(delta):
	for key in hoveredDict:
		if(hoveredDict[key] == true):
			key.modulate.a += 2.1*delta
		else:
			key.modulate.a -= 2.1*delta
		key.modulate.a = clamp(key.modulate.a, 0.55, 0.9)