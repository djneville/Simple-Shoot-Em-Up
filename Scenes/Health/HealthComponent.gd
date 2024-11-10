extends Node

@export var max_health := 7
var health := max_health

signal health_changed(health)
signal entity_died()

func take_damage(damage):
    health -= damage
    health_changed.emit(health)
    if health <= 0:
        entity_died.emit()

func heal(amount):
    health = min(health + amount, max_health)
    health_changed.emit(health)
