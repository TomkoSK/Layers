extends Node2D

var velocity = 0
var maxSpeed = 500

func _ready():
	UIButtons.set_visibility("ui", false)
	$Camera2D/BackButton.modulate.a = 0.76

func _on_back_button_pressed():
	SceneManager.changeScene("res://Scenes/MainMenu.tscn")

func _on_back_button_mouse_exited():
	$Camera2D/BackButton.modulate.a = 0.76

func _on_back_button_mouse_entered():
	$Camera2D/BackButton.modulate.a = 0.9

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				$Camera2D.position.y -= 20
				$Camera2D.position.y = clamp($Camera2D.position.y, 540, 750)
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				$Camera2D.position.y += 20
				$Camera2D.position.y = clamp($Camera2D.position.y, 540, 750)
	if(event.is_action_pressed("ui_cancel")):
		$Camera2D/BackButton.emit_signal("pressed")

func _process(delta):#unnecesarily complicated smooth scrolling when using the arrows
	if(Input.is_action_pressed("ui_up")):
		velocity -= 1200*delta
		velocity = clamp(velocity, -maxSpeed, maxSpeed)
	elif(Input.is_action_pressed("ui_down")):
		velocity += 1200*delta
		velocity = clamp(velocity, -maxSpeed, maxSpeed)
	else:
		if(velocity < 0):
			if(velocity >= -42):
				velocity = 0
			else:
				velocity += 42
		elif(velocity > 0):
			if(velocity <= 42):
				velocity = 0
			else:
				velocity -= 42
	$Camera2D.position.y += velocity*delta
	$Camera2D.position.y = clamp($Camera2D.position.y, 540, 750)