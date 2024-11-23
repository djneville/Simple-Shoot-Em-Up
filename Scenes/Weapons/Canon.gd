extends Weapon
class_name Canon

var bomb_inventory: int:
    set = set_bomb_inventory,
    get = get_bomb_inventory
var max_bomb_inventory: int:
    set = set_max_bomb_inventory,
    get = get_max_bomb_inventory

signal bomb_inventory_change(new_bomb_inventory: int)


func _ready() -> void:
    self.set_fire_rate(1.5)
    self.set_max_bomb_inventory(7)
    self.set_bomb_inventory(get_max_bomb_inventory())
    self.set_projectile_type(ProjectileType.TYPE.BOMB)
    super._ready()


func fire(shooter: Node, _position: Vector2, direction: Vector2):
    if can_fire():
        super.fire(shooter, _position, direction)
        set_bomb_inventory(bomb_inventory - 1)


func get_bomb_inventory() -> int:
    return bomb_inventory


func set_bomb_inventory(value: int) -> void:
    bomb_inventory = value
    self.bomb_inventory_change.emit(self.bomb_inventory)


func get_max_bomb_inventory() -> int:
    return max_bomb_inventory


func set_max_bomb_inventory(value: int) -> void:
    max_bomb_inventory = value
#TODO: this could also use a signal if we want to have increases during upgrade events
#self.bomb_inventory_change.emit(self.bomb_inventory)
