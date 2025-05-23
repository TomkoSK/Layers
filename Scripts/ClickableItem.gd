@tool
extends Interactable

@export var dialogue : Array[String]
@export var pickUpItem : bool
@export var item : InventoryItem
@export var itemAmount : int
var formattedDialogue : Array[Array]

func _ready():
    for line in dialogue:
        formattedDialogue.append(["", line])
        if(!Engine.is_editor_hint()):
            $Sprite/Outline.hide()

func _on_hitbox_input_event(_viewport:Node, event:InputEvent, _shape_idx:int):
    if(event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
        DialoguePlayer.playDialogue(formattedDialogue)
        $Hitbox.hide()
        await DialoguePlayer.dialogueFinished
        $Hitbox.show()
        if(pickUpItem):
            var freeSpace = Inventory.checkFreeSpace(item)
            if(freeSpace >= itemAmount):
                Inventory.addItem(item, itemAmount)
                UIButtons.showNotification("Picked up %dx %s" % [itemAmount, item.name])
                queue_free()
            elif(freeSpace > 0):
                Inventory.addItem(item, freeSpace)
                UIButtons.showNotification("Picked up %dx %s" % [freeSpace, item.name])
            else:
                UIButtons.showNotification("Not enough space to pick up")