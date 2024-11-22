extends Weapon
class_name Canon

func _ready() -> void:
    self.set_fire_rate(1.5)
    self.set_projectile_type(ProjectileType.TYPE.BOMB)
    super._ready()
