extends Node

var previousScene = null

func _ready():
	var windowMode = DisplayServer.window_get_mode()
	if(windowMode == 0 or windowMode == 1 or windowMode == 2):#All the windowed modes
		$VBoxContainer/WindowMode/OptionButton.selected = 1#windowed index
	else:
		$VBoxContainer/WindowMode/OptionButton.selected = 0
	$VBoxContainer/MusicContainer/HSlider.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$VBoxContainer/VolumeContainer/HSlider.value = db_to_linear(AudioServer.get_bus_volume_db(2))

func _on_settings_applied():
	ProjectSettings.save()
	DisplayServer.window_set_mode(ProjectSettings.get_setting("display/window/size/mode"))#Sets the window mode immediately

func _on_window_mode_changed(index:int):
	ProjectSettings.set_setting("display/window/size/mode", $VBoxContainer/WindowMode/OptionButton.get_item_id(index))

func _on_back_button_pressed():
	SceneManager.changeScene(previousScene)

func _on_music_slider_changed(value: float):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))

func _on_volume_slider_changed(value: float):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))