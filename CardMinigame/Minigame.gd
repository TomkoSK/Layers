extends Node2D

func _on_button_button_down():
	var card = await SceneManager.selectMinigameCard()
	print(card.value)