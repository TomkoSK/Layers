extends Node2D

var t
var loading_text
var testContainer
var testNode
var textNode
var shortPause
var longPause

func _ready():
	testContainer = $PanelContainer2
	#testNode = $PanelContainer2/Label
	textNode = $PanelContainer/Label
	shortPause = Timer.new()
	shortPause.set_wait_time(0.15)
	self.add_child(shortPause)
	longPause = Timer.new()
	longPause.set_wait_time(0.3)
	self.add_child(longPause)

func formatText(text):
	#The way the function works is it uses the testNode label to find out how long a piece of text is, and it splits the text
	#when it gets longer than the textBox, its a really simple concept but there is some black magic code because of spaces
	#and stuff
	var textArray = text.split(" ")
	var returnedArray = []
	var index = 0
	while(index < len(textArray)):
		var length = 0
		while(length < 1513 and index < len(textArray)):#917 is the size of the text container
			if(length > 0):#Adds a BEFORE every word except the first one so that the size isn't incorrect
				testNode.text += " "
			testNode.text += textArray[index]
			length = testContainer.get_minimum_size().x
			index += 1
		if(length >= 1513):#this means there are still more words, the last word added gets removed from the text
			index -= 1
			testNode.text = testNode.text.left(-(len(textArray[index])+1))#removes the last word and the space
		returnedArray.append(testNode.text)
		testNode.text = "" 
	return returnedArray

func checkDot(text, lineIndex, charIndex):#checks if a dot in the text is a part of ... or just a standalone sentence end
	#0 means its not part of a ..., 1 means it is a part of a ... and 2 means its the last . of a ... and there should be a pause
	if(charIndex > 1):
		if(text[lineIndex][charIndex-1] == "." and text[lineIndex][charIndex-2] == "."):
			return 2
	if(charIndex == 0):
		if(text[lineIndex][charIndex+1] == "."):
			return 1
	elif(charIndex == len(text[lineIndex])-1):
		if(text[lineIndex][charIndex-1] == "."):
			return 1
	else:
		if(text[lineIndex][charIndex-1] == "." or text[lineIndex][charIndex+1] == "."):
			return 1
	return 0

func checkShortPause(text, lineIndex, charIndex):
	var pauseCharacters = ["?", "!", ","]#. is not in the list because its special (also needs to checkDot())
	if((text[lineIndex][charIndex] == "." and checkDot(text, lineIndex, charIndex) == 0) or pauseCharacters.has(text[lineIndex][charIndex])):
		if(charIndex < len(text[lineIndex])-1):
			if(text[lineIndex][charIndex+1] == ")"):
				return false
		return true
	else:
		return false

func checkLongPause(text, lineIndex, charIndex):
	var enders = ["?", "!", ")", ","]#The list of characters that ... shouldn't cause a pause in front of
	if(text[lineIndex][charIndex] == "." and checkDot(text, lineIndex, charIndex) == 2):
		if(charIndex < len(text[lineIndex])-1):
			if(enders.has(text[lineIndex][charIndex+1])):#If the end of a ... comes before a ! ? or a ), the pause looks really
														 #weird so the pause just doesn't happen instead
				return false
		return true
	if(text[lineIndex][charIndex] == "\n"):
		return true
	return false

func init(text, texturePaths = null, profilePicture = null, timerLength = 0.03):
	if(text[0] == "(" and text[-1] == ")"):
		textNode.label_settings = load("res://TextBoxBlue.tres")
	var formattedText = formatText(text)	
	if(timerLength > 0):
		t = Timer.new()
		t.set_wait_time(timerLength)
		t.set_one_shot(false)
		self.add_child(t)
	
	if(profilePicture != null):
		var sprite = Sprite2D.new()
		sprite.texture = load(profilePicture)
		sprite.position = Vector2(-803, 390)#Position acquired through manual testing
		sprite.z_index = 11
		#PFP SIZE SHOULD BE 274x259
		self.add_child(sprite)

	if(texturePaths != null):
		if(len(texturePaths) == 2):
			var sprite = Sprite2D.new()
			sprite.texture = load(texturePaths[0])
			sprite.position = Vector2(-400, 130)
			sprite.z_index = 9
			self.add_child(sprite)
			sprite = Sprite2D.new()
			sprite.texture = load(texturePaths[1])
			sprite.position = Vector2(400, 130)
			sprite.z_index = 9
			self.add_child(sprite)
		elif(len(texturePaths) == 1):
			var sprite = Sprite2D.new()
			sprite.texture = load(texturePaths[0])
			sprite.position = Vector2(0, 130)
			sprite.z_index = 9
			self.add_child(sprite)
		else:
			print("[WARNING] Array of a size that's not 1 or 2 was passed into Textbox idk if this is what you want")

	if(timerLength > 0):
		loading_text = true
		t.start()
		var lineIndex = 0
		for i in range(len(formattedText)):
			for j in range(len(formattedText[i])):
				if(loading_text):
					textNode.text += formattedText[i][j]
					if(checkShortPause(formattedText, i, j)):
						shortPause.start()
						await shortPause.timeout
					if(checkLongPause(formattedText, i, j)):
						longPause.start()
						await longPause.timeout
					await t.timeout
				else:#If not loading text anymore, hitbox was clicked, end text is shown instantly and init is exited
					if(len(formattedText) > 1):
						textNode.text = formattedText[-2]+"\n"+formattedText[-1]
					else:
						textNode.text = formattedText[0]
					return
			textNode.text += "\n"
			lineIndex += 1
			if(lineIndex > 1 and lineIndex < len(formattedText)):#Only prints the last 2 lines of text after getting to 3rd line
				#or further, but it looks weird if it does this on the last line
				textNode.text = formattedText[lineIndex-1]+"\n"
		t.stop()
		loading_text = false
	else:
		textNode.text = text

func _on_hitbox_pressed():
	if(loading_text):
		loading_text = false
	else:
		queue_free()

func _input(event):
	if(event.is_action_pressed("SkipTextbox")):
		if(loading_text):
			loading_text = false
		else:
			queue_free()
