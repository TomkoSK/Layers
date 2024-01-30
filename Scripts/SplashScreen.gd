extends Node2D

var maxOpacity = 1
var changeDuration = 0.9

func _ready():
	UIButtons.set_visibility("ui", false)
	$Logo.modulate.a = 0
	var tween = self.create_tween()
	tween.tween_property($Logo, "modulate", Color(1, 1, 1, maxOpacity), changeDuration)
	await get_tree().create_timer(changeDuration).timeout
	await get_tree().create_timer(0.7).timeout
	tween = self.create_tween()
	tween.tween_property($Logo, "modulate", Color(1, 1, 1, 0), changeDuration)
	await get_tree().create_timer(changeDuration).timeout
	SceneManager.changeScene("res://Scenes/MainMenu.tscn", 0, 0.7, 2, true)
