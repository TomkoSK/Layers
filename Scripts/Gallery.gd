extends Node2D

var frameTexture = preload("res://Gallery/CGframe.png")
var images = []

func _ready():
	UIButtons.set_visibility("ui", false)
	$BackButton.modulate.a = 0.55

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				$Camera2D.position.y -= 20
				$Camera2D.position.y = clamp($Camera2D.position.y, 0, max(len(images)*270-900, 0))
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				$Camera2D.position.y += 20
				$Camera2D.position.y = clamp($Camera2D.position.y, 0, max(len(images)*270-900, 0))
	if(event.is_action_pressed("ui_accept")):
		addImage("res://Gallery/testBG.png")

func addImage(imagePath : String):
	var offset = len(images)
	var x
	if(offset%2 == 0):
		x = 525	
	else:
		x = 1395
	var y = 450+(540*(offset/2))
	var spriteNode = Sprite2D.new()
	spriteNode.texture = load(imagePath)
	spriteNode.position = Vector2(x, y)
	spriteNode.scale = Vector2(0.385, 0.385)
	var frameNode = Sprite2D.new()
	frameNode.texture = frameTexture
	frameNode.scale = Vector2(1/0.385, 1/0.385)
	spriteNode.add_child(frameNode)
	var buttonNode = Button.new()
	buttonNode.size = Vector2(740, 410)
	buttonNode.scale = Vector2(1/0.385, 1/0.385)
	buttonNode.position = Vector2(-960, -540)
	buttonNode.self_modulate.a = 0
	spriteNode.add_child(buttonNode)
	$Images.add_child(spriteNode)
	images.append(spriteNode)
	buttonNode.button_down.connect(openImage.bind(spriteNode))

func openImage(spriteNode : Sprite2D):
	$CanvasLayer/Sprite2D.texture = spriteNode.texture
	$CanvasLayer/Sprite2D.self_modulate.a = 0
	$CanvasLayer.show()
	var tween = self.create_tween()
	tween.tween_property($CanvasLayer/Sprite2D, "self_modulate", Color(1, 1, 1, 1), 0.15)

func _on_close_button_pressed():
	$CanvasLayer/CloseButton.hide()
	var tween = self.create_tween()
	tween.tween_property($CanvasLayer/Sprite2D, "self_modulate", Color(1, 1, 1, 0), 0.15)
	await get_tree().create_timer(0.15).timeout
	$CanvasLayer.hide()
	$CanvasLayer/CloseButton.show()

func _on_back_button_pressed():
	SceneManager.changeScene("res://Scenes/MainMenu.tscn")

func _on_back_button_mouse_exited():
	$BackButton.modulate.a = 0.55

func _on_back_button_mouse_entered():
	$BackButton.modulate.a = 0.9