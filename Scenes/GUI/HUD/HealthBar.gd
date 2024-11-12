extends TextureProgressBar

func _ready():
    #TODO: figure out how to just get the Player Node right off the bat, no need for groups
    var players = get_tree().get_nodes_in_group("player")
    var player = players[0]
    
    var health = player.get_node("HealthComponent")

    health.health_changed.connect(_on_health_changed)
    # initialized health
    self.value = health.health

# Signal handler for health changes
func _on_health_changed(new_health):
    self.value = new_health
