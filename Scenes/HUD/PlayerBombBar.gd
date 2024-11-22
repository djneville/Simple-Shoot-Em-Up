extends TextureProgressBar
class_name PlayerBombBar

var canon: Canon = null


func _ready() -> void:
    var players: Array = get_tree().get_nodes_in_group("player")
    var player: CharacterBody2D = players[0]
    var upgrade_component: UpgradeComponent = player.get_node("UpgradeComponent")
    #TODO: the weapons_updated signal is not working
    upgrade_component.weapons_updated.connect(_on_weapons_updated)


func _try_get_canon(upgrade_component: UpgradeComponent) -> void:
    canon = upgrade_component.get_node("Canon")
    if canon:
        canon.bomb_inventory_change.connect(_on_bomb_inventory_change)
        self.value = canon.get_bomb_inventory()
    else:
        print("Canon node not found in UpgradeComponent")

func _on_weapons_updated():
    var players: Array = get_tree().get_nodes_in_group("player")
    var player: CharacterBody2D = players[0]
    var upgrade_component: UpgradeComponent = player.get_node("UpgradeComponent")
    upgrade_component.weapons_updated.disconnect(_on_weapons_updated)
    _try_get_canon(upgrade_component)

func _on_bomb_inventory_change(new_bomb_inventory: int) -> void:
    self.value = new_bomb_inventory
