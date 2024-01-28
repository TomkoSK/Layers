extends Node2D

var maxOpacity = 1
var startOpacity = 0.0
var changeDuration = 0.4

func _ready():
	UIButtons.set_visibility("ui", false)
	var currentOpacity = startOpacity
	$Logo.modulate.a = startOpacity
	for i in range(50):
		currentOpacity += (maxOpacity-startOpacity)/50
		$Logo.modulate.a = currentOpacity
		await get_tree().create_timer(changeDuration/50).timeout
	await get_tree().create_timer(0.7).timeout
	for i in range(50):
		currentOpacity -= (maxOpacity-startOpacity)/50
		$Logo.modulate.a = currentOpacity
		await get_tree().create_timer(changeDuration/50).timeout
	SceneManager.changeScene("res://Scenes/MainMenu.tscn", 0.2, 0.5, 2)
