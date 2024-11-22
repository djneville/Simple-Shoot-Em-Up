extends Projectile
class_name Bomb

@onready var bullet_sprite: Sprite2D = $BulletSprite
@onready var bullet_explosion_sprite: Sprite2D = $BulletExplosionSprite


#OVERRIDE
func _on_impact() -> void:
    self.bullet_explosion_sprite.visible = true
    self.bullet_sprite.visible = false
    self.queue_free()
