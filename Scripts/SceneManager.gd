extends Node

signal sceneSwitched

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
	#changeScene("res://Scenes/MainMenu.tscn", 0.02, 0.5, 2)

func openSettings():
	var currentScene = get_tree().current_scene.scene_file_path
	changeScene("res://Scenes/Settings.tscn")
	await Signal(self, "sceneSwitched")
	get_tree().current_scene.previousScene = currentScene

func openSaveSlots(mode : String):#The mode thing is explained in SaveSlots.gd, this function just switches to the save slots scene
	#and sets the mode, the mode setting is what requires this to be another function instead of just using changeScene
	changeScene("res://Scenes/SaveSlots.tscn")
	await Signal(self, "sceneSwitched")
	get_tree().current_scene.mode = mode

func changeScene(targetScene, fadeIn = 0.4, midLength = 0.4, fadeOut = 0.4):
	$CanvasLayer/Button.show()
	fadeLengthIn = fadeIn
	fadeLengthOut = fadeOut
	sprite = Sprite2D.new()
	sprite.texture = load("res://Textures/square.png")
	sprite.scale = Vector2(4000, 4000)
	sprite.position = Vector2(0, 0)
	sprite.modulate = Color(0, 0, 0, 0)
	sprite.z_index = 20
	self.add_child(sprite)

	var t1 = Timer.new()
	t1.set_wait_time(fadeLengthIn)
	self.add_child(t1)
	var t2 = Timer.new()
	t2.set_wait_time(fadeLengthOut)
	self.add_child(t2)

	t1.start()
	fadingIn = true
	await t1.timeout
	fadingIn = false
	opacity = 1
	get_tree().change_scene_to_file(targetScene)

	var timer = Timer.new()
	timer.set_wait_time(midLength)
	self.add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()

	fadingAway = true
	t2.start()
	await t2.timeout
	fadingAway = false
	opacity = 0
	sprite.queue_free()
	t1.queue_free()
	t2.queue_free()

	sceneSwitched.emit()
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
