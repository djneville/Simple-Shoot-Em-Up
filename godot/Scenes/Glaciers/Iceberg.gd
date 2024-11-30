extends Node2D
class_name Iceberg

@export var mass: int = 10
@export var size: Vector2 = Vector2(32, 32)


func _ready() -> void:
    _setup_particles()


func _setup_particles() -> void:
    # Hint: Configure a particle system to simulate ice dust or snow around the iceberg
    print("Particle system setup: Configure particles here.")
