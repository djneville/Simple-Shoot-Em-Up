extends Node2D
class_name HealthComponent

@export var max_health := 7
@export var health := max_health

signal health_changed(health)
signal entity_died()

func take_damage(damage):
    print("Health for", self.get_parent().name, "is NOW: ", health)
    health -= damage
    health_changed.emit(health)
    if health <= 0:
        entity_died.emit()

func heal(amount):
    health = min(health + amount, max_health)
    health_changed.emit(health)
