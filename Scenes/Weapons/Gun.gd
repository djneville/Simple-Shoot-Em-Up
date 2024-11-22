extends Weapon
class_name Gun

func _ready() -> void:
    self.set_fire_rate(0.25)
    self.set_projectile_type(ProjectileType.TYPE.BULLET)
    super._ready()

func fire(shooter: Node, position: Vector2, direction: Vector2):
    if can_fire():
        $MuzzleFlash.play("MuzzleFlashAnimation")
        super.fire(shooter, position, direction)  # Call the base class fire
