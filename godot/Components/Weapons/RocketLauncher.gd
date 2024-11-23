extends MissileLauncher
class_name RocketLauncher


func _ready() -> void:
    self.set_projectile_type(ProjectileType.TYPE.BOSS_MISSILE)
    super._ready()
