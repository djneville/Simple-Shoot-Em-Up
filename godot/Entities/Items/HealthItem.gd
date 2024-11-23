extends Area2D
class_name HealthItem

@export var item_type: ItemType.TYPE = ItemType.TYPE.HEALTH


func _ready() -> void:
    body_entered.connect(_on_body_entered)


func _on_body_entered(body: CharacterBody2D) -> void:
    if body.is_in_group("player"):
        body.heal()
        queue_free()
