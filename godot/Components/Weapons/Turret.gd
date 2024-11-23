extends Gun
class_name Turret


func _ready() -> void:
    self.set_fire_rate(0.10)
    self.set_projectile_type(ProjectileType.TYPE.BOSS_BULLET)
    super._ready()
