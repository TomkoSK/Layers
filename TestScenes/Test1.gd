extends Node2D

var greenAmog

func _ready():
	UIButtons.set_visibility("ui", true)
	greenAmog = ResourceLoader.load("res://Inventory/Items/Green.tres")
	var i = 0
	for sprite in $Sprites.get_children():
		sprite.position.x = 300+i*150
		sprite.position.y = 450
		i += 1
	i = 0
	for label in $Labels.get_children():
		label.position.x = 320+i*150
		label.position.y = 460
		i += 1
		label.text = ""

func _process(delta: float) -> void:
	var items = Inventory.getItems()
	for i in range(len(items)):
		$Sprites.get_child(i).texture = load(items[i].texturePath)
		if(items[i].amount > 1):
			$Labels.get_child(i).text = str(items[i].amount)

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("SkipTextbox")):
		Inventory.addItem(greenAmog, 1)