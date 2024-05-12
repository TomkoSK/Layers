extends Node2D

signal cardSelected
var score = 0#variable used for development 
var playerCard = null
var playerCards = []

func cardSpread(cardList : Array, centerPoint : Vector2, instant : bool = true, duration : float = 0.05):
    var cardCount = len(cardList)
    var spreadAngle = 22.0/12*(cardCount-1)#Spread angle is 22 degrees at most, and shrinks to match the lesser amount of cards
    var basePoint = (180-spreadAngle)/2#Used for keeping the spread in the middle of the 180 degree plane
    var thing#Used to calculate the rotation of each individual card later
    if(cardCount == 1):
        thing = spreadAngle/float(cardCount)#the float prevents integer division
    else:
        thing = spreadAngle/float(cardCount-1)#the float prevents integer division
    for i in range(cardCount):
        if(instant):
            cardList[i].position.x = centerPoint.x-cos(deg_to_rad(180-basePoint-thing*i))*2700
            cardList[i].position.y = centerPoint.y-sin(deg_to_rad(180-basePoint-thing*i))*2700
            cardList[i].rotation_degrees = 180-basePoint-thing*i-90
        else:#If spread is not instant, cards instead float towards their position and rotation smoothly
            var tween = self.create_tween()
            var x = centerPoint.x-cos(deg_to_rad(180-basePoint-thing*i))*2700
            var y = centerPoint.y-sin(deg_to_rad(180-basePoint-thing*i))*2700
            tween.tween_property(cardList[i], "position", Vector2(x, y), duration)
            tween = self.create_tween()
            tween.tween_property(cardList[i], "rotation_degrees", 180-basePoint-thing*i-90, duration)

func _ready():
    UIButtons.set_visibility("ui", false)
    var cardRes = load("res://CardMinigame/Card.tscn")
    for i in range(13, 0, -1):#-1 step in for loop to make the cards show up in ascending order (the card spread goes from right to left)
        var card = cardRes.instantiate()
        card.init(i, "res://CardTextures/%s.png" % i)
        card.connect("card_clicked", card_clicked)
        card.position.x = 100+i*120
        card.position.y = 880
        self.add_child(card)
        playerCards.append(card)
    cardSpread(playerCards, Vector2(960, 3600))

func card_clicked(card):
    playerCards.erase(card)
    card.setExpanding(false)
    var transitionTime = card.position.distance_to(Vector2(960, 440))/380
    var tween = self.create_tween()
    tween.tween_property(card, "position", Vector2(960, 440), transitionTime)
    tween.tween_callback(setPlayerCard.bind(card)).set_delay(0.5)
    tween = self.create_tween()
    tween.tween_property(card, "rotation_degrees", 0, transitionTime)#beause of the card spread, the card isn't perfectly rotated all the time
    await get_tree().create_timer(transitionTime/2).timeout
    cardSpread(playerCards, Vector2(960, 3600), false, 0.2)

func setPlayerCard(card):
    playerCard = card
    cardSelected.emit()