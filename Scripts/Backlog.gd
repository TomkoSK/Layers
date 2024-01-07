extends Node2D

var formattedText = []#This will be an array of all the text lines in the backlog, in this format: [["line1text"], ["line2text"], ["line3text"], etc]
#Each line is an array of its own because if a line in the backlog also has a character name, it will be like this: [["line1charactername", "line1text"], ["line2text"]]
var testContainer
var testNode
#Array of text and names for each line, the backlog has 12 lines so the array has 12 elements 
var names = ["", "", "", "", "", "", "", "", "", "", "", ""]
var textLines = ["", "", "", "", "", "", "", "", "", "", "", ""]
#Just used when resetting the names and textLines arrays back to their empty state in updateArrays()
var namesReset = ["", "", "", "", "", "", "", "", "", "", "", ""]
var textLinesReset = ["", "", "", "", "", "", "", "", "", "", "", ""]

func _ready():
	self.hide()
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
	var textArray#NOTE: put comments here explaining whats happening
	textLines = textLinesReset
	names = namesReset
	if(len(formattedText) > 12):
		textArray = formattedText.slice(-12, -1)
	else:
		textArray = formattedText
	for i in range(len(textArray)):
		if(len(textArray[i]) > 1):
			names[i] = textArray[i][0]
			textLines[i] = textArray[i][1]
		else:
			textLines[i] = textArray[i][0]
	refreshText()

func addText(text):#textlines with the character name and the text will be passed to this function, in a format of ["CharacterName", "text"]
	var charName = text[0]
	#All of this is stolen from the textbox script and changed a bit :3, it breaks down the text into individual lines
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
			formattedText.append(textLineArray[i])
	updateArrays()