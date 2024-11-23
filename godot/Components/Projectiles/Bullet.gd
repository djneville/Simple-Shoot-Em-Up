extends Projectile
class_name Bullet

func _on_impact() -> void:
    $AnimationPlayer.play("Explode")
    $AnimationPlayer.animation_finished.connect(_on_animation_timeout)

func _on_animation_timeout(anim_name: String) -> void:
    if anim_name == "Explode": #TODO: not sure if i need to check this EVERY time when a signal has an parameter
        self.queue_free()
