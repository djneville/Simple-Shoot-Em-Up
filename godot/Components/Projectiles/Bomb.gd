extends Projectile
class_name Bomb

@export var explosion_radius: float = 100.0

@onready var explosion_area: Area2D = $ExplosionArea
@onready var bomb_sprite: Sprite2D = $BombSprite
@onready var bomb_explosion_animation: AnimationPlayer = $BombExplosionAnimation


func _on_lifetime_timeout() -> void:
    self.explode()


func _on_impact() -> void:
    self.explode()


func explode() -> void:
    self.bomb_sprite.visible = false
    self.bomb_explosion_animation.play("BombExplosion")
    self.explosion_area.body_entered.connect(_on_explosion_body_entered)
    self.bomb_explosion_animation.animation_finished.connect(_on_animation_finished)


func _on_explosion_body_entered(body: Node) -> void:
    if body == self.projectile_owner:
        return
    body.take_damage(self.damage)


func _on_animation_finished(anim_name: String) -> void:
    if anim_name == "BombExplosion":
        self.queue_free()
