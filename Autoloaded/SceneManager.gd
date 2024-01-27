extends Node

signal sceneSwitched

var developing = false#MAKES ALL THE TRANSITIONS INSTANT TURN OFF WHEN UPLOADING NEW VERSION TO BE PLAYED
var sprite : Sprite2D
var opacity : float = 0
var fadingAway : bool
var fadingIn : bool
var fadeLengthIn : float
var fadeLengthOut : float
var bgSprite : Sprite2D

func _ready():
	bgSprite = Sprite2D.new()
	bgSprite.position = Vector2(960, 540)#middle of the screen
	bgSprite.z_index = -10#its literally the background so u know
	self.add_child(bgSprite)
	changeScene("res://Scenes/MainMenu.tscn", 0.02, 0.5, 2)

func openSettings(includeMenuButton : bool = false):
	var currentScene = get_tree().current_scene.scene_file_path
	changeScene("res://Scenes/Settings.tscn")
	await Signal(self, "sceneSwitched")
	get_tree().current_scene.previousScene = currentScene
	get_tree().current_scene.setMenuButton(includeMenuButton)#The way to get back to the menu from the game is through the settings,
	#so the includeMenuButton argument is just deciding whether or not the menu button in the settings should be shown

func openSaveSlots(mode : String):#The mode thing is explained in SaveSlots.gd, this function just switches to the save slots scene
	#and sets the mode, the mode setting is what requires this to be another function instead of just using changeScene
	changeScene("res://Scenes/SaveSlots.tscn")
	await Signal(self, "sceneSwitched")
	get_tree().current_scene.mode = mode

func changeScene(targetScene, fadeIn = 0.4, midLength = 0.4, fadeOut = 0.4):
	if(developing):
		fadeIn = 0.01
		midLength = 0.01
		fadeOut = 0.01
	$CanvasLayer/Button.show()
	var scene = load(targetScene).instantiate()
	fadeLengthIn = fadeIn
	fadeLengthOut = fadeOut
	sprite = Sprite2D.new()
	sprite.texture = load("res://Textures/square.png")
	sprite.scale = Vector2(4000, 4000)
	sprite.position = Vector2(0, 0)
	sprite.modulate = Color(0, 0, 0, 0)
	sprite.z_index = 20
	self.add_child(sprite)
	fadingIn = true
	await get_tree().create_timer(fadeLengthIn).timeout
	fadingIn = false
	opacity = 1
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(scene)
	get_tree().set_current_scene(scene)
	sceneSwitched.emit()
	await get_tree().create_timer(midLength).timeout
	fadingAway = true
	await get_tree().create_timer(fadeLengthOut).timeout
	fadingAway = false
	opacity = 0
	sprite.queue_free()
	$CanvasLayer/Button.hide()

func setBackground(bgPath):
	bgSprite.texture = load(bgPath)

func _process(delta):
	if(fadingAway):
		opacity -= 1*(delta/fadeLengthOut)
		sprite.modulate.a = opacity
	if(fadingIn):
		opacity += 1*(delta/fadeLengthIn)
		sprite.modulate.a = opacity