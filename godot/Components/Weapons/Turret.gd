extends Gun
class_name Turret


func _ready() -> void:
    super._ready()
    #TODO: this ordering is horrendous, and a great reason as to why inheretence just gets ugly as heck
    self.set_projectile_type(ProjectileType.TYPE.BOSS_BULLET)
    self.set_fire_rate(0.10)
