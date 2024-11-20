extends Node2D
class_name HealthComponent

# Export Variables
@export var max_health: int = 7
@export var current_health: int = max_health:
    set(value):
        current_health = value
        self.health_changed.emit(current_health)

# Signals
signal health_changed(new_health: int)
signal entity_died

# Constants
const MIN_HEALTH: int = 0


func _init() -> void:
    # Initialize non-node dependent properties
    self.set_process(false)


func _ready() -> void:
    # Emit initial health value
    self.health_changed.emit(self.current_health)
    self.set_process(true)


func take_damage(damage: int) -> void:
    var new_health: int = self.current_health - damage
    self._update_health(new_health)

    if self.current_health <= MIN_HEALTH:
        self._handle_death()


func heal(amount: int) -> void:
    var new_health: int = mini(self.current_health + amount, self.max_health)
    self._update_health(new_health)


func _update_health(new_value: int) -> void:
    self.current_health = new_value


func _handle_death() -> void:
    self.entity_died.emit()


# Getters/Setters
func get_current_health() -> int:
    return self.current_health


func get_max_health() -> int:
    return self.max_health


func get_health_percentage() -> float:
    return (float(self.current_health) / float(self.max_health)) * 100.0
