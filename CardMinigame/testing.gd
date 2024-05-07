extends Node2D

var score = 0
var playerTurn = false
var enemyTurn = true
var enemyCard = null
var playerCard = null
var playerCards = []
var enemyCards = []

func _ready():
    UIButtons.set_visibility("ui", false)
    var cardRes = load("res://CardMinigame/Card.tscn")
    for i in range(1, 14):
        var card = cardRes.instantiate()
        card.init(i, "res://CardTextures/%s.png" % i)
        card.connect("card_clicked", card_clicked)
        card.position.x = 100+i*120
        card.position.y = 880
        self.add_child(card)
        playerCards.append(card)

    for i in range(1, 14):
        var card = cardRes.instantiate()
        card.init(i, "res://CardTextures/%s.png" % i)
        card.flip()
        card.setExpanding(false)
        card.position.x = 100+i*120
        card.position.y = 120
        self.add_child(card)
        enemyCards.append(card)
    enemyPlay()

func enemyPlay():
    var rng = RandomNumberGenerator.new()
    var index = rng.randi_range(0, len(enemyCards)-1)
    var card = enemyCards[index]
    enemyCards.erase(card)
    var tween = self.create_tween()
    tween.tween_property(card, "position", Vector2(960, 340), 1.2)
    tween.tween_callback(setEnemyCard.bind(card))

func card_clicked(card, value):
    if(playerTurn):
        playerCards.erase(card)
        var tween = self.create_tween()
        tween.tween_property(card, "position", Vector2(960, 640), 1.2)
        tween.tween_callback(setPlayerCard.bind(card))

func setPlayerCard(card):
    playerCard = card
    playerTurn = false

func setEnemyCard(card):
    enemyCard = card
    enemyTurn = false
    playerTurn = true

func _process(_delta):
    if(enemyCard and playerCard and not enemyTurn):
        enemyCard.flip()
        if(enemyCard.value > playerCard.value):
            score -= 1
            $Label.text = str(score)
        else:
            score += 1
            $Label.text = str(score)
        enemyTurn = true
        await get_tree().create_timer(2).timeout
        enemyCard.queue_free()
        playerCard.queue_free()
        enemyCard = null
        playerCard = null
        enemyPlay()