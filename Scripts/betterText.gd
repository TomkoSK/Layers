extends Node2D

var loading_text
var testContainer
var testNode
var textNode

var time = 0
var formattedText
var lineNumber = 0
var characterNumber = 0
var timeBetweenCharacters

func _ready():
	testContainer = $PanelContainer2
	testNode = $PanelContainer2/Label
	textNode = $PanelContainer/Label

func formatText(text):
	#The way the function works is it uses the testNode label to find out how long a piece of text is, and it splits the text
	#when it gets longer than the textBox, its a really simple concept but there is some black magic code because of spaces
	#and stuff
	var textArray = text.split(" ")
	var returnedArray = []
	var index = 0
	while(index < len(textArray)):
		var length = 0
		while(length < 1513 and index < len(textArray)):#1513 is the size of the text container
			if(length > 0):#Adds a BEFORE every word except the first one so that the size isn't incorrect
				testNode.text += " "
			testNode.text += textArray[index]
			length = testContainer.get_minimum_size().x
			if(textArray[index][-1] == "\n"):#ends the line early if there is a \n character
				index += 1
				break
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
	if(lineIndex == len(formattedText)-1 and charIndex == len(formattedText[lineIndex])-1):
		return false
	var pauseCharacters = ["?", "!", ","]#. is not in the list because its special (also needs to checkDot())
	if((text[lineIndex][charIndex] == "." and checkDot(text, lineIndex, charIndex) == 0) or pauseCharacters.has(text[lineIndex][charIndex])):
		if(charIndex < len(text[lineIndex])-1):
			if(text[lineIndex][charIndex+1] == ")"):
				return false
		return true
	else:
		return false

func checkLongPause(text, lineIndex, charIndex):
	if(lineIndex == len(formattedText)-1 and charIndex == len(formattedText[lineIndex])-1):
		return false
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
	timeBetweenCharacters = timerLength
	if(text[0] == "(" and text[-1] == ")"):
		textNode.label_settings = load("res://TextBoxBlue.tres")
	formattedText = formatText(text)	

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
	loading_text = true

func _process(delta):#Text is loaded in _process, because if you want a letter to show up every 0.03 seconds,
					#using normal timers is bad for it (timers with a length of less than 0.05 can behave weirdly)
	if(loading_text):
		time += delta
		if(time >= timeBetweenCharacters):
			time = 0
			if(characterNumber >= len(formattedText[lineNumber])):
				characterNumber = 0
				lineNumber += 1
				if(lineNumber < len(formattedText)):
					if(formattedText[lineNumber-1][-1] == "\n"):#Text line can be ended early by putting in \n in the dialogue,
						#if it wasnt ended manually a \n is appended automatically instead
						textNode.text = formattedText[lineNumber-1]
					else:
						textNode.text = formattedText[lineNumber-1]+"\n"
				if(lineNumber >= len(formattedText)):
					loading_text = false
					return
			textNode.text += formattedText[lineNumber][characterNumber]
			if(checkShortPause(formattedText, lineNumber, characterNumber)):
				time -= 0.15
			if(checkLongPause(formattedText, lineNumber, characterNumber)):
				time -= 0.3
			characterNumber += 1

func showText():#Shows the last 2 lines when the text box is clicked while its text is being loading
	if(len(formattedText) > 1):
		textNode.text = formattedText[-2]+"\n"+formattedText[-1]
	else:
		textNode.text = formattedText[0]

func _on_hitbox_pressed():
	if(loading_text):
		loading_text = false
		showText()
	else:
		queue_free()

func _input(event):
	if(event.is_action_pressed("SkipTextbox")):
		if(loading_text):
			loading_text = false
			showText()
		else:
			queue_free()
