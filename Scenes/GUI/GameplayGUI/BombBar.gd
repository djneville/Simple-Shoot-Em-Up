extends TextureProgressBar

func _ready():
    #TODO: figure out how to just get the Player Node right off the bat, no need for groups
    var players = get_tree().get_nodes_in_group("player")
    var player = players[0]
    
    var weapon = player.get_node("WeaponComponent")

    weapon.bomb_inventory_change.connect(_on_bomb_inventory_change)
    
    self.value = weapon.bomb_inventory

# Signal handler for health changes
func _on_bomb_inventory_change(new_bomb_inventory):
    self.value = new_bomb_inventory
