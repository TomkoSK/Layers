extends Node2D

func _ready():
	$Button/Backlog.addText(["SUSMASTER", "this better work on god fr no cap no cap fr fr on god"])
	$Button/Backlog.addText(["SUSSY", "backlog testing :3"])
	$Button/Backlog.updateArrays()

func _on_button_pressed():
	$Button/Backlog.refreshText()
