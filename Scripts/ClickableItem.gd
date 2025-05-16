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
        # $Sprite/Outline.hide() #Outline doesn't register the exit due to the dialogue bo appearing, hidden manually
        $Hitbox.hide()
        await DialoguePlayer.dialogueFinished
        $Hitbox.show()