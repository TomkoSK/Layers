extends Node2D

func _ready():
	var item = load("res://CardMinigame/Items/CardReveal.tscn").instantiate()
	item.connect("itemClicked", itemClicked)
	self.add_child(item)

func itemClicked(itemName : String):
	print(itemName)