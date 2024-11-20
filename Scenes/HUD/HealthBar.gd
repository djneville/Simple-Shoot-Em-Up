# res://Scripts/HealthBar.gd
extends TextureProgressBar
class_name HealthBar

# Reference to the Player's HealthComponent
var health_component: HealthComponent = null


func _ready() -> void:
	# TODO: figure out how to just get the Player Node right off the bat, no need for groups
	var players: Array = get_tree().get_nodes_in_group("player")
	var player: Node = players[0]

	var health_node: HealthComponent = player.get_node("HealthComponent") as HealthComponent
	self.health_component = health_node
	self.health_component.health_changed.connect(self._on_health_changed)

	# Initialize health bar value
	self.value = self.health_component.get_current_health()


# Setter for health_component
func set_health_component(component: HealthComponent) -> void:
	self.health_component = component


# Signal handler for health changes
func _on_health_changed(new_health: int) -> void:
	self.value = new_health
