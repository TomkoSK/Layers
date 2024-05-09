extends Node2D

var score = 0
var playerTurn = false
var enemyCard = null
var playerCard = null
var playerCards = []
var enemyCards = []

func cardSpread(cardList : Array, centerPoint : Vector2, instant : bool = true, duration : float = 0.05):
    var cardCount = len(cardList)
    var spreadAngle = 30.0
    var basePoint = (180-spreadAngle)/2
    var thing
    if(cardCount == 1):
        thing = spreadAngle/float(cardCount)#the float prevents integer division
    else:
        thing = spreadAngle/float(cardCount-1)#the float prevents integer division
    for i in range(cardCount):
        if(instant):
            cardList[i].position.x = centerPoint.x-cos(deg_to_rad(180-basePoint-thing*i))*900
            cardList[i].position.y = centerPoint.y-sin(deg_to_rad(180-basePoint-thing*i))*750
            cardList[i].rotation_degrees = 180-basePoint-thing*i-90
        else:
            var tween = self.create_tween()
            var x = centerPoint.x-cos(deg_to_rad(180-basePoint-thing*i))*900
            var y = centerPoint.y-sin(deg_to_rad(180-basePoint-thing*i))*750
            tween.tween_property(cardList[i], "position", Vector2(x, y), duration)
            tween = self.create_tween()
            tween.tween_property(cardList[i], "rotation_degrees", 180-basePoint-thing*i-90, duration)

func _ready():
    UIButtons.set_visibility("ui", false)
    var cardRes = load("res://CardMinigame/Card.tscn")
    for i in range(13, 0, -1):
        var card = cardRes.instantiate()
        card.init(i, "res://CardTextures/%s.png" % i)
        card.connect("card_clicked", card_clicked)
        card.position.x = 100+i*120
        card.position.y = 880
        self.add_child(card)
        playerCards.append(card)
    cardSpread(playerCards, Vector2(960, 1650))

    for i in range(1, 14):
        var card = cardRes.instantiate()
        card.init(i, "res://CardTextures/%s.png" % i)
        card.flip()
        card.setExpanding(false)
        card.position.x = 100+i*120
        card.position.y = 120
        self.add_child(card)
        enemyCards.append(card)
    cardSpread(enemyCards, Vector2(960, 850))
    enemyPlay()

func enemyPlay():
    var rng = RandomNumberGenerator.new()
    var index = rng.randi_range(0, len(enemyCards)-1)
    var card = enemyCards[index]
    enemyCards.erase(card)
    var tween = self.create_tween()
    tween.tween_property(card, "position", Vector2(960, 340), 1.2)
    tween.tween_callback(setEnemyCard.bind(card))
    tween = self.create_tween()
    tween.tween_property(card, "rotation_degrees", 0, 1.2)#beause of the card spread, the card isn't perfectly rotated all the time
    await get_tree().create_timer(0.8).timeout
    cardSpread(enemyCards, Vector2(960, 850), false, 0.2)

func card_clicked(card):
    if(playerTurn):
        playerTurn = false#player turn needs to be set immediately so that no more cards may be clicked
        playerCards.erase(card)
        card.setExpanding(false)
        var tween = self.create_tween()
        tween.tween_property(card, "position", Vector2(960, 640), 1.2)
        tween.tween_callback(setPlayerCard.bind(card))
        tween = self.create_tween()
        tween.tween_property(card, "rotation_degrees", 0, 1.2)#beause of the card spread, the card isn't perfectly rotated all the time
        await get_tree().create_timer(0.8).timeout
        cardSpread(playerCards, Vector2(960, 1650), false, 0.2)

func setPlayerCard(card):
    playerCard = card
    evaluateCards()

func setEnemyCard(card):
    enemyCard = card
    playerTurn = true

func evaluateCards():
    enemyCard.flip()
    if(enemyCard.value > playerCard.value):
        score -= 1
        $Label.text = str(score)
    else:
        score += 1
        $Label.text = str(score)
    await get_tree().create_timer(2).timeout
    enemyCard.queue_free()
    playerCard.queue_free()
    enemyCard = null
    playerCard = null
    enemyPlay()