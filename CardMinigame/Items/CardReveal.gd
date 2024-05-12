extends Node2D

signal itemClicked(itemName : String)

func _on_button_button_down():
	itemClicked.emit("cardReveal")
