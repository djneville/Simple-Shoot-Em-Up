extends TextureProgressBar
class_name BossHealthBar

#TODO: change visibilty based on when a boss is PRESENT OR NOT!!!

var boss_health_component: HealthComponent = null


func _ready() -> void:
    var bosses: Array = get_tree().get_nodes_in_group("boss")
    if bosses.size() == 0:
        return
    var boss: Node = bosses[0]
    #TODO: this is gross merge it with the player health bar just different visual same code
    var health_node: HealthComponent = boss.get_node("HealthComponent") as HealthComponent
    self.boss_health_component = health_node
    self.boss_health_component.health_changed.connect(self._on_health_changed)

    self.value = self.boss_health_component.get_current_health()


# Setter for health_component
func set_health_component(component: HealthComponent) -> void:
    self.boss_health_component = component


# Signal handler for health changes
func _on_health_changed(new_health: int) -> void:
    self.progress_bar.value = new_health
