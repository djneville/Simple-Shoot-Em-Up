extends Weapon
class_name MissileLauncher

func _ready() -> void:
    self.set_fire_rate(4.0)
    self.set_projectile_type(ProjectileType.TYPE.MISSILE)
    super._ready()

func fire(shooter: Node, position: Vector2, direction: Vector2):
    if can_fire():
        $MuzzleFlash.play("MuzzleFlashAnimation")
        super.fire(shooter, position, direction)
