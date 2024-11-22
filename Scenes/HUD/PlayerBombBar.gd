extends TextureProgressBar
class_name PlayerBombBar


func _ready() -> void:
    #TODO: figure out how to just get the Player Node right off the bat, no need for groups
    var players: Array = get_tree().get_nodes_in_group("player")
    var player: CharacterBody2D = players[0]

    var weapon: WeaponComponent = player.get_node("WeaponComponent")

    weapon.bomb_inventory_change.connect(_on_bomb_inventory_change)

    self.value = weapon.bomb_inventory


# Signal handler for health changes
func _on_bomb_inventory_change(new_bomb_inventory: int) -> void:
    self.value = new_bomb_inventory
