extends Node2D

func _ready():
	await get_tree().create_timer(0.6).timeout
	UIButtons.showNotification("ipmopsrotre")