extends MissileLauncher
class_name RocketLauncher


func _ready() -> void:
    super._ready()
    self.set_projectile_type(ProjectileType.TYPE.BOSS_MISSILE)
