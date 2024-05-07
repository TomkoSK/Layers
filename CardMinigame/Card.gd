extends Node2D

signal card_clicked(card : Node2D, value : int)

var coveredTexture = load("res://CardTextures/card_check.png")
var showingTexture = null
var showing = true
var expandOnHover = true
var value = null

func init(numberValue : int, texturePath : String):
	value = numberValue
	$Sprite.texture = load(texturePath)
	showingTexture = load(texturePath)

func flip(visibility = null):
	if(visibility == null):
		showing = !showing
	else:
		showing = visibility
	if(showing):
		$Sprite.texture = showingTexture
	else:
		$Sprite.texture = coveredTexture

func setExpanding(expand : bool):
	expandOnHover = expand

func _on_collider_mouse_exited():
	var tween = self.create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.12)

func _on_collider_mouse_entered():
	if(expandOnHover):
		var tween = self.create_tween()
		tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.12)

func _on_collider_button_down():
	card_clicked.emit(self, value)