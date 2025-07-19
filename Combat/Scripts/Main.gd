extends Node2D

enum damageTypes{PHYSICAL, MAGIC}

signal on_attack(value, type : damageTypes, aoe : bool, affected : Array)
signal on_damage(value : int, type : damageTypes, aoe : bool, affected : Array)
signal on_heal(value : int, aoe : bool)
signal combat_start
signal turn_start

var characters : Array

func _ready():
    combat_start.emit()