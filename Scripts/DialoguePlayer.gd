extends Node
func playDialogue(dialogueList):#ARGUMENTS IN THIS FORMAT: [["characterName", "text", "res://TexturePath", "res://PfpTexture", 0.03]]
	var characters = [null, null]
	var oldestIndex = 0
	var node = load("res://Scenes/BetterText.tscn")
	var profilePicture = null
	var timerLength
	for text in dialogueList:
		if(len(text) > 2 and text[2] != null):#adds a character texture path and removes the oldest one if there are too many already
			if(not characters.has(text[2])):
				characters[oldestIndex] = text[2]
				if(oldestIndex == 1):
					oldestIndex = 0
				else:
					oldestIndex = 1
		if(len(text) > 3 and text[3] != null):#sets a profile picture if passed
			profilePicture = text[3]
		else:
			profilePicture = null
		if(len(text) > 4):#set the timer's length if passed
			timerLength = text[4]
		else:
			timerLength = 0.03
		var textBox = node.instantiate()
		get_tree().root.add_child(textBox)
		#done to remove the nulls from the character texture list (nulls in the list fuck up the text box code)
		var tempList = []
		for ch in characters:
			if(ch != null):
				tempList.append(ch)
		if(len(tempList) == 0):#Cant pass empty list into the textbox
			tempList = null
		textBox.init(text[1], tempList, profilePicture, timerLength)
		await Signal(textBox, "tree_exited")
		Backlog.addText([text[0], text[1]])
