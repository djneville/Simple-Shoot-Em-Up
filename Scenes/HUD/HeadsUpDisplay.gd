extends Control
class_name HeadsUpDisplay

var boss_health_component: HealthComponent = null

func _ready() -> void:
    SignalBus.boss_entered.connect(init_boss_healthbar)


func init_boss_healthbar():
    var bosses: Array = get_tree().get_nodes_in_group("boss")
    $VBoxContainer.show()
    var boss: BossEntity = bosses[0]
    #TODO: this is gross merge it with the player health bar just different visual same code
    self.boss_health_component = boss.get_node("HealthComponent") as HealthComponent
    self.boss_health_component.health_changed.connect(self._on_boss_health_changed)
    #TODO: what eww, make this next part just automatically get set in a better way
    $VBoxContainer/BossHealthBar.max_value = self.boss_health_component.get_max_health()
    $VBoxContainer/BossHealthBar.value = self.boss_health_component.get_current_health()

func _on_boss_health_changed(new_health: int) -> void:
    $VBoxContainer/BossHealthBar.value = new_health
