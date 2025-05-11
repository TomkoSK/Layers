extends Node

signal sceneSwitched

var switchingScenes = false
var developing = false#MAKES ALL THE TRANSITIONS INSTANT TURN OFF WHEN UPLOADING NEW VERSION TO BE PLAYED
var bgSprite : Sprite2D

func _ready():
	bgSprite = Sprite2D.new()
	bgSprite.position = Vector2(960, 540)#middle of the screen
	bgSprite.z_index = -10#its literally the background so u know
	self.add_child(bgSprite)

func selectMinigameCard():#Used in CardMinigame/Minigame.gd to let the player select a card
	var previousScene = get_tree().current_scene
	changeScene("res://CardMinigame/CardSelection.tscn", 0.4, 0.4, 0.4, false, false)
	await Signal(self, "sceneSwitched")
	var currentScene = get_tree().current_scene
	await Signal(currentScene, "cardSelected")
	var card = currentScene.playerCard
	changeScene(previousScene)
	return card


func openSettings(includeMenuButton : bool = false):
	if(!switchingScenes):
		var currentScene = get_tree().current_scene.scene_file_path
		changeScene("res://Scenes/Settings.tscn")
		await Signal(self, "sceneSwitched")
		get_tree().current_scene.previousScene = currentScene
		get_tree().current_scene.setMenuButton(includeMenuButton)#The way to get back to the menu from the game is through the settings,
		#so the includeMenuButton argument is just deciding whether or not the menu button in the settings should be shown

func openSaveSlots(mode : String):#The mode thing is explained in SaveSlots.gd, this function just switches to the save slots scene
	#and sets the mode, the mode setting is what requires this to be another function instead of just using changeScene
	if(!switchingScenes):
		changeScene("res://Scenes/SaveSlots.tscn")
		await Signal(self, "sceneSwitched")
		get_tree().current_scene.mode = mode

func changeScene(targetScene, fadeIn = 0.4, midLength = 0.4, fadeOut = 0.4, changeAfterMidTimer : bool = false, freeObject = true):
	if(developing):
		fadeIn = 0
		midLength = 0
		fadeOut = 0
	if(!switchingScenes):
		switchingScenes = true
		var scene
		if(typeof(targetScene) == TYPE_STRING):#if targetScene is string, its a path to the scene to be loaded
			scene = load(targetScene).instantiate()
		elif(typeof(targetScene) == TYPE_OBJECT):#if its an object, its the instantiated scene itself
			scene = targetScene
		var sprite = Sprite2D.new()
		sprite.texture = load("res://Textures/square.png")
		sprite.scale = Vector2(4000, 4000)
		sprite.position = Vector2(0, 0)
		sprite.modulate = Color(0, 0, 0, 0)
		sprite.z_index = 20
		self.add_child(sprite)

		if(fadeIn > 0):
			var tween = self.create_tween()
			tween.tween_property(sprite, "modulate", Color(0, 0, 0, 1), fadeIn)
			await get_tree().create_timer(fadeIn).timeout
		else:
			sprite.modulate.a = 1
		
		if(!changeAfterMidTimer):
			if(freeObject):#if it is needed to return to the previous scene instance sometime after, the scene object needs
			#to not be queue_free()'d, only removed as a child of the tree
				get_tree().current_scene.queue_free()
			else:
				get_tree().root.remove_child(get_tree().current_scene)
			get_tree().root.add_child(scene)
			get_tree().set_current_scene(scene)
			sceneSwitched.emit()

		if(midLength > 0):
			await get_tree().create_timer(midLength).timeout
		
		if(changeAfterMidTimer):
			if(freeObject):#if it is needed to return to the previous scene instance sometime after, the scene object needs
			#to not be queue_free()'d, only removed as a child of the tree
				get_tree().current_scene.queue_free()
			else:
				get_tree().root.remove_child(get_tree().current_scene)
			get_tree().root.add_child(scene)
			get_tree().set_current_scene(scene)
			sceneSwitched.emit()

		if(fadeOut > 0):
			var tween = self.create_tween()
			tween.tween_property(sprite, "modulate", Color(0, 0, 0, 0), fadeOut)
			await get_tree().create_timer(fadeOut*0.4).timeout
			switchingScenes = false#Makes the player able to switch the scene again after the black screen fades away a bit
			await get_tree().create_timer(fadeOut*0.6).timeout
		else:
			sprite.modulate.a = 0
			switchingScenes = false
		sprite.queue_free()

func setBackgroundFromPath(bgPath : String):
	bgSprite.texture = load(bgPath)

func setBackgroundTexture(texture : Texture2D):
	bgSprite.texture = texture