extends Node2D

var formattedText = []#This will be an array of all the text lines in the backlog, in this format: [["line1text"], ["line2text"], ["line3text"], etc]
#Each line is an array of its own because if a line in the backlog also has a character name, it will be like this: [["line1charactername", "line1text"], ["line2text"]]
var testContainer
var testNode
#Array of text and names for each line, the backlog has 12 lines so the array has 12 elements 
var names = ["", "", "", "", "", "", "", "", "", "", "", ""]
var textLines = ["", "", "", "", "", "", "", "", "", "", "", ""]
var scrollOffset = 0

func _ready():
	self.close()
	#the testContainer and testNode are used in the same way as in the textbox script, they are for testing how big a string is
	testContainer = $TestContainer
	testNode = $TestContainer/TestLabel

func refreshText():#Just gets the text and names from names and textLines and puts it on the backlog
	$Text.text = ""
	$CharacterNames.text = ""
	for i in range(12):
		$Text.text += textLines[i]+"\n"
		$CharacterNames.text += names[i]+"\n"

func updateArrays():#Updates the text in names and textLines based on whatever is in the formattedText
	var previousName = ""
	var textArray
	for i in range(12):
		names[i] = ""
		textLines[i] = ""#Resets both the arrays to their empty state
	if(len(formattedText) > 12):
		if(scrollOffset == 0):#Scroll offset is the amount the player has scrolled up in the backlog
			textArray = formattedText.slice(-12)#If the offset is 0, just print the last 12 lines of the backlog
		else:
			textArray = formattedText.slice(-12+scrollOffset, scrollOffset)#Otherwise prints the last 12 lines but offset by the scroll amount
	else:#If there arent more than 12 lines just print the whole formattedText
		textArray = formattedText

	for i in range(len(textArray)):#Puts every line into the arrays
		if(len(textArray[i]) > 1):#If the length is more than 1 it means there is also a character name in the line
			textLines[i] = textArray[i][1]#sets the text line to the line in the array
			if(previousName == textArray[i][0]):#This exists so that if a character has 2 lines in a row in the backlog, the name is only shown in the first line
				pass
			else:
				previousName = textArray[i][0]
				names[i] = textArray[i][0] 
		else:
			textLines[i] = textArray[i][0]#sets the text line to the line in the array
	refreshText()#Finally refreshes the text after updating the arrays

func removeNewlines(text):
	while(text.find("\n") != -1):#Keeps looping until it can't find any more \n characters
		text = text.substr(0, text.find("\n"))+" "+text.substr(text.find("\n")+1)#Makes the string a substring of itself with every character except the \n
		#The space is added where the \n used to be 
		#because without the newline, there needs to be something between the words (there is no space between the words)
		#idk how to explain it well just please dont remove the space :3
	return text

func addText(text):#textlines with the character name and the text will be passed to this function, in a format of ["CharacterName", "text"]
	var charName = text[0]
	#All of this is stolen from the textbox script and changed a bit :3, it breaks down the text into individual lines
	text[1] = removeNewlines(text[1])
	var textArray = text[1].split(" ")#Splits the text into individual words
	var textLineArray = []#Array of the text split into individual lines
	var index = 0
	while(index < len(textArray)):
		var length = 0
		while(length < 1344 and index < len(textArray)):#1344 is the pixel size of the text label
			if(length > 0):#Adds a space BEFORE every word except the first one (if the space is added after the word the size testing is incorrect because the space adds to the size)
				testNode.text += " "
			testNode.text += textArray[index]
			length = testContainer.get_minimum_size().x#Gets the size of the text
			index += 1
		if(length >= 1344):#this means there are still more words, the last word added gets removed from the text
			index -= 1
			testNode.text = testNode.text.left(-(len(textArray[index])+1))#removes the last word and the space
		textLineArray.append(testNode.text)
		testNode.text = "" 
	formattedText.append([charName, textLineArray[0]])
	if(len(textLineArray) > 1):
		for i in range(1, len(textLineArray)):
			formattedText.append([textLineArray[i]])
	updateArrays()

func _input(event):
	if(event.is_action_pressed("ui_cancel")):
		close()
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				scrollOffset -= 1
				scrollOffset = clamp(scrollOffset, -(len(formattedText)-12), 0)
				updateArrays()
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				scrollOffset += 1
				scrollOffset = clamp(scrollOffset, -(len(formattedText)-12), 0)
				updateArrays()

func open():#The hitboxes are on another canvas layer so that clicking them takes priority over everything else, the layer also has to be 
	#manually hidden, thats why the custom show and hide function
	self.show()
	$CanvasLayer.visible = true

func close():
	self.hide()
	$CanvasLayer.visible = false

func _on_button_pressed():#Hides the backlog when the empty region around it is clicked
	close()