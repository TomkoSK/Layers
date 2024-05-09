extends Node

var cardList = []
var cardCount = 13
var midpoint = Vector2(960, 800)
var spreadAngle = 45.0
var angleMinus = float(spreadAngle)/float(cardCount-1)


func cardClick(card):
	cardList.erase(card)
	cardCount = len(cardList)
	spreadAngle -= angleMinus
	print(spreadAngle)
	card.queue_free()
	cardSpread(false)

func cardSpread(instant : bool = true):
	var basePoint = (180-spreadAngle)/2
	var thing
	if(cardCount == 1):
		thing = spreadAngle/float(cardCount)#the float prevents integer division
	else:
		thing = spreadAngle/float(cardCount-1)#the float prevents integer division
	for i in range(cardCount):
		if(instant):
			cardList[i].position.x = midpoint.x-cos(deg_to_rad(180-basePoint-thing*i))*420
			cardList[i].position.y = midpoint.y-sin(deg_to_rad(180-basePoint-thing*i))*420
			cardList[i].rotation_degrees = 180-basePoint-thing*i-90
		else:
			var tween = self.create_tween()
			var x = midpoint.x-cos(deg_to_rad(180-basePoint-thing*i))*420
			var y = midpoint.y-sin(deg_to_rad(180-basePoint-thing*i))*420
			tween.tween_property(cardList[i], "position", Vector2(x, y), 0.05)
			tween = self.create_tween()
			tween.tween_property(cardList[i], "rotation_degrees", 180-basePoint-thing*i-90, 0.05)


# Called when the node enters the scene tree for the first time.
func _ready():
	var cardRes = load("res://CardMinigame/Card.tscn")
	for i in range(1, cardCount+1):
		var card = cardRes.instantiate()
		card.init(i, "res://CardTextures/%s.png" % i)
		card.connect("card_clicked", cardClick)
		self.add_child(card)
		cardList.append(card)
	cardSpread()