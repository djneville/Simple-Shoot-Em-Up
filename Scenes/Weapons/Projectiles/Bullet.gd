extends Projectile
class_name Bullet

@onready var bullet_sprite: Sprite2D = $BulletSprite
@onready var bullet_explosion_sprite: Sprite2D = $BulletExplosionSprite


func _ready() -> void:
    #$MissileExplosionAnimation.animation_finished.connect(queue_free)
    super._ready()


#OVERRIDE
func _on_impact() -> void:
    self.bullet_explosion_sprite.show()
    self.bullet_sprite.visible = false
#$MissileExplosionSprites.show()
#$MissileExplosionAnimation.play("MissileExplosion")
