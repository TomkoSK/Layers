extends Node

"""
The inventory is drawn on a separate layer canvas because 
the iventory buttons need to take input first
"""
var emptyItem
var slots
var itemList

func _ready():
	self.visible = false
	emptyItem = load("res://Resources/emptyItem.tres")
	itemList = load("res://Resources/InventoryItems.tres")
	slots = [$CanvasLayer/Slot1, $CanvasLayer/Slot2, $CanvasLayer/Slot3, $CanvasLayer/Slot4, $CanvasLayer/Slot5, $CanvasLayer/Slot6]
	updateItems()

func insertItem(item):
	for slot in itemList.slots:
		if(slot == emptyItem):
			print("penis")
			itemList.slots[itemList.slots.find(slot)] = item#Replaces the empty slot with the item
			updateItems()
			ResourceSaver.save(itemList, "res://Resources/InventoryItems.tres")
			return

func removeItem(item):
	for slot in itemList.slots:
		if(slot == item):
			itemList.slots[itemList.slots.find(slot)] = emptyItem#Replaces the item with a empty slot
			updateItems()
			ResourceSaver.save(itemList, "res://Resources/InventoryItems.tres")
			return

func checkItemAmount(item):
	var amount = 0
	for slot in itemList.slots:
		if(slot == item):
			amount += 1
	return amount

func updateItems():
	for i in range(len(slots)):
		slots[i].icon = load(itemList.slots[i].texturePath)

func show():
	self.visible = true
	$CanvasLayer.visible = true

func _on_exit_hitbox_pressed():
		self.visible = false
		$CanvasLayer.visible = false
