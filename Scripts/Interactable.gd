@tool
class_name Interactable extends Node2D

@export_file("*.png", "*.jpg") var texturePath : String:
	set(value):
		texturePath = value
		if(Engine.is_editor_hint()):
			if(texturePath):
				var newTexture = load(texturePath)
				$Sprite.texture = newTexture
				$Sprite/Outline.texture = newTexture
				$Hitbox/CollisionShape2D.shape.size = Vector2($Sprite.texture.get_width(), $Sprite.texture.get_height())
			else:
				$Sprite.texture = null
				$Sprite/Outline.texture = null	

@export var outlineColor : Color:
	set(value):
		outlineColor = value
		if(Engine.is_editor_hint()):
			$Sprite/Outline.material.set_shader_parameter("color", outlineColor)

@export_range(0.0, 50.0) var outlineWidth : float:
	set(value):
		outlineWidth = value
		if(Engine.is_editor_hint()):
			$Sprite/Outline.material.set_shader_parameter("outlineSize", outlineWidth)

@export_range(0.0, 0.05) var outlineBlur : float:
	set(value):
		outlineBlur = value
		if(Engine.is_editor_hint()):
			$Sprite/Outline.material.set_shader_parameter("blur", outlineBlur)

@export_range(0.0, 0.99) var outlineOpacityThreshold : float:
	set(value):
		outlineOpacityThreshold = value
		if(Engine.is_editor_hint()):
			$Sprite/Outline.material.set_shader_parameter("opacityThreshold", outlineOpacityThreshold)

@export_range(1, 5) var blurSteps : int:
	set(value):
		blurSteps = value
		if(Engine.is_editor_hint()):
			$Sprite/Outline.material.set_shader_parameter("blurSteps", blurSteps)

func _ready():
	if(!Engine.is_editor_hint()):
		$Sprite/Outline.hide()

func _on_hitbox_mouse_entered():
	$Sprite/Outline.show()

func _on_hitbox_mouse_exited():
	$Sprite/Outline.hide()
