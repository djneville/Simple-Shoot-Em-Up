extends Control
class_name HeadsUpDisplay

# Health Components
var boss_health_component: HealthComponent = null
var player_health_component: HealthComponent = null

# Bomb Components
var canon: Canon = null

# References
var player: PlayerEntity = null
var upgrade_component: UpgradeComponent = null


func _ready() -> void:
    _update_score_text()
    _update_lives_text()
    SignalBus.lives_updated.connect(_update_lives_text)
    SignalBus.score_updated.connect(_update_score_text)
    SignalBus.boss_entered.connect(init_boss_healthbar)
    init_player_hud()


func _update_score_text():
    $HBoxContainer1/ScoreNumber.text = str(GameStatsManager.score)


func _update_lives_text():
    $HBoxContainer2/LivesNumber.text = str(GameStatsManager.lives)


func init_boss_healthbar():
    var bosses: Array = get_tree().get_nodes_in_group("boss")
    $VBoxContainer.show()
    var boss: BossEntity = bosses[0]

    boss_health_component = boss.get_node("HealthComponent") as HealthComponent
    boss_health_component.health_changed.connect(_on_boss_health_changed)
    $VBoxContainer/BossHealthBar.max_value = boss_health_component.get_max_health()
    $VBoxContainer/BossHealthBar.value = boss_health_component.get_current_health()


func _on_boss_health_changed(new_health: int) -> void:
    $VBoxContainer/BossHealthBar.value = new_health


func init_player_hud():
    init_player_healthbar()
    init_player_bombbar()


func init_player_healthbar():
    var players: Array = get_tree().get_nodes_in_group("player")
    player = players[0] as PlayerEntity
    player_health_component = player.get_node("HealthComponent") as HealthComponent
    player_health_component.health_changed.connect(_on_player_health_changed)
    $PlayerHealthBar.max_value = player_health_component.get_max_health()
    $PlayerHealthBar.value = player_health_component.get_current_health()


func _on_player_health_changed(new_health: int) -> void:
    $PlayerHealthBar.value = new_health


func init_player_bombbar():
    upgrade_component = player.get_node("UpgradeComponent") as UpgradeComponent
    # Attempt to get Canon immediately
    _try_get_canon(upgrade_component)

    # Connect to weapons_updated to handle future upgrades
    upgrade_component.weapons_updated.connect(_on_weapons_updated)


func _try_get_canon(upgrade_component: UpgradeComponent) -> void:
    if upgrade_component.has_node("Canon"):
        var canon_node: Canon = upgrade_component.get_node("Canon")
        if canon_node:
            canon = canon_node
            # Connect to bomb_inventory_change if not already connected
            if not canon.bomb_inventory_change.is_connected(_on_bomb_inventory_change):
                canon.bomb_inventory_change.connect(_on_bomb_inventory_change)
            # Initialize BombBar

            # Optionally, handle the absence of Canon here or wait for an upgrade
            $PlayerBombBar.max_value = canon.get_max_bomb_inventory()
            $PlayerBombBar.value = canon.get_bomb_inventory()

        # Optionally, handle the absence of Canon here or wait for an upgrade
        else:
            print("HeadsUpDisplay: Canon node is null")

    # Optionally, handle the absence of Canon here or wait for an upgrade
    else:
        print("HeadsUpDisplay: UpgradeComponent does not have a Canon node")


# Optionally, handle the absence of Canon here or wait for an upgrade


func _on_weapons_updated():
    if not canon and upgrade_component:
        _try_get_canon(upgrade_component)


func _on_bomb_inventory_change(new_bomb_inventory: int) -> void:
    $PlayerBombBar.value = new_bomb_inventory
