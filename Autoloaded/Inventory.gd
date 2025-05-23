extends Node

var itemsFileLocation = "user://Resources/Inventory/InventoryItems.tres"

var itemArray : InventoryItemArray

const MAX_ITEMS = 1

func _ready() -> void:
    if(ResourceLoader.exists(itemsFileLocation, "InventoryItemArray")):
        itemArray = ResourceLoader.load(itemsFileLocation)
    else:
        itemArray = InventoryItemArray.new()

## returns how much of a given item would currently fit in the player's inventory, or how many free 
## slots the inventory has if [Sprite2D] is omitted
func checkFreeSpace(item : InventoryItem = null) -> int:
    if(item == null):
        return MAX_ITEMS-len(itemArray.items)#number of free slots
    else:
        var freeSpace = (MAX_ITEMS-len(itemArray.items))*item.stackSize#base free space from free slots
        for arrayItem in itemArray.items:
            if(arrayItem.id == item.id):#free space from incomplete stacks of items in the inventory
                freeSpace += item.stackSize-arrayItem.amount
        return freeSpace

func checkItemCount(item: InventoryItem) -> int:
    var amount := 0
    for arrayItem in itemArray.items:
        if(arrayItem.id == item.id):
            amount += arrayItem.amount
    return amount

func getItems() -> Array:
    return itemArray.items

## returns True if it succeeds[br]
## returns False if the inventory doesn't have enough space for the amount of the given item
func addItem(item : InventoryItem, amount : int = 1) -> bool:
    print(checkFreeSpace(item))
    if(checkFreeSpace(item) < amount):
        push_error("Add item function in Inventory.gd failed, item: %s, amount: %d" % [item.name, amount])
        return false
    else:
        var amountLeft = amount
        for i in range(len(itemArray.items)):
            var currentItem = itemArray.items[i]#just for better readability, assigned by reference
            if(currentItem.id == item.id):
                if(amountLeft > currentItem.stackSize-currentItem.amount):#if slot doesn't have enough space, it keeps going
                    amountLeft -= currentItem.stackSize-currentItem.amount
                    currentItem.amount = currentItem.stackSize
                else:#otherwise it returns
                    currentItem.amount += amountLeft
                    return true
        #if filling existing item slots isn't enough, they are added as new items (this won't exceed the inventory limit for sure
        #because of the checkFreeSpace())
        var duplicateItem : InventoryItem
        while(amountLeft > 0):
            duplicateItem = item.duplicate()
            duplicateItem.amount = min(duplicateItem.stackSize, amountLeft)
            itemArray.items.append(duplicateItem)
            amountLeft -= duplicateItem.stackSize
        return true
                

## returns True if it succeeds[br]
## returns False if the inventory doesn't have enough of the given item
func removeItem(item : InventoryItem, amount : int) -> bool:
    #it first checks if the inventory has enough of the item to remove, shows a warning and returns False if not
    var amountFound = checkItemCount(item)
    if(amountFound < amount):
        push_error("Remove item function in Inventory.gd failed, item: %s, amount: %d" % [item.name, amount])
        return false

    var amountLeft := amount
    var i = 0
    
    while(i < len(itemArray.items)):
        var currentItem = itemArray.items[i]#just for better readability, assigned by reference
        if(currentItem.ID == item.ID):
            if(amountLeft >= currentItem.amount):#removes the item from the array completely if it's not enough to fulfill the amount
                amountLeft -= currentItem.amount
                itemArray.items.remove_at(i)
                if(amountLeft == 0):#edge case
                    return true
                continue#continue so that i isn't incremented (all elements are moved by -1 because of the remove)
            else:
                currentItem.amount -= amountLeft
                return true#if it fulfills the amount, the function is over
        i+=1
    
    assert(false, "Remove item function in Inventory.gd reached a point it should never reach")
    return false
        
func save():
    ResourceSaver.save(itemArray, itemsFileLocation)