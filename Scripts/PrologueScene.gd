extends Node

#BIG NOTE: IF YOU PUT A \n CHARACTER IN THE DIALOGUE, PUT A SPACE AFTER IT! IF YOU DONT, THE TEXTBOX CODE *WILL NOT* WORK

func _ready():
	AudioManager.setAmbiencePlaying(true)
	AudioManager.setAmbienceVolume(0)
	AudioManager.setAmbienceVolume(1, 3)
	UIButtons.set_visibility("ui", false)
	for line in dialogue:
		var listToAppend = [line[1], line[0]]
		formattedDialogue.append(listToAppend)
	call_deferred("scene")#Called as deferred so that the engine has time to set up objects and stuff idk it threw an error before

#ar dialogue = [["Remy... ​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​there's a layer there.", "Cat"],["I know.", "Remy"], ["It's moving towards you...", "Cat"],
#"I know.", "Remy"], ["Can't you... climb out?", "Cat"], ["What do you think I'm trying to do right now?", "Remy"],
#"S-sorry...", "Cat"], ["It's fine.", "Remy"], ["W-what should I do?", "Cat"], ["I don't...\nI don't know!", "Remy"],
#"(Just one misstep, and this happens? God...)", "Remy"], ["Remy...", "Cat"], ["Hey. Look away for a moment.", "Remy"],
#"B-but...", "Cat"], ["Just shut up and listen!", "Remy"], ["...", "Cat"], ["Leave me here for a while. There's an opening down below, and I'm going to try and drop down there, okay?", "Remy"],
#"I'll try to get back to you, but it might take a while. Just... keep going until we see each other again, okay?", "Remy"],
#"W-wh... Well, yeah! Okay! I'll see you soon, right?", "Cat"], ["Don't get your hopes up, you know how this place moves, cat.", "Remy"],
#"Reach the nearest safe spot, alright? I'll try to get there.", "Remy"], ["...", "Cat"], ["What're you doing? Hurry up and go.", "Remy"],
#"Okay...", "Cat"], ["Good. I'll meet you in the future, cat.", "Remy"], ["M-mhm! Thank you, Rem!", "Cat"], ["Just go.", "Remy"],
#"S-seeya!", "Cat"], ["(Ahh, the cat's gone. Ugh.\nThere's... really no exit here...)", "Remy"],
#"(...No way I can make it out of this, right?)", "Remy"], ["(Yeah... no way.)", "Remy"], ["Ahh... why...\nDamn it.", "Remy"],
#"(That one...? If it moves down... no...\nI don't... want to imagine that...)", "Remy"], ["This... I'm-", "Remy"],
#"(It cut my leg so deep... I can't patch the injury...)", "Remy"], ["(I can't believe I messed up like that, damn it!\nHow could I have...)", "Remy"],
#"(That... screeching... twisting... grating metal...)", "Remy"], ["Just this once. Please. in some way... that lets me go...", "Remy"],
#"...C-come on...\nPlease move.", "Remy"], ["(The one behind me, huh?)", "Remy"], ["(God... please help that cat. No way they survive here.)", "Remy"],
#"(Why am I even praying?\nI hate this place.\nThis world... so shrill and unpleasant. I hate it.)", "Remy"], ["(I’m...)", "Remy"]
#

var dialogue = [["(Why am I even praying?\n I hate this place.\n This world... so shrill and unpleasant. I hate it.)", "Remy"]]
var formattedDialogue = []#The dialogue is formatted into proper DialoguePlayer acceptable dialogue through code

func scene():
	DialoguePlayer.playDialogue(formattedDialogue)
	await Signal(DialoguePlayer, "dialogueFinished")
	UIButtons.set_visibility("options", true)
