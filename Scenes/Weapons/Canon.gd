extends Weapon
class_name Canon

var bomb_inventory: int:
    set = set_bomb_inventory, get = get_bomb_inventory
var max_bomb_inventory: int:
    get = get_max_bomb_inventory

signal bomb_inventory_change(new_bomb_inventory: int)

func _ready() -> void:
    self.set_fire_rate(1.5)
    self.set_projectile_type(ProjectileType.TYPE.BOMB)
    super._ready()

func get_bomb_inventory() -> int:
    return bomb_inventory

func set_bomb_inventory(value: int) -> void:
    bomb_inventory = value
    self.bomb_inventory_change.emit(self.bomb_inventory)


func get_max_bomb_inventory() -> int:
    return max_bomb_inventory
