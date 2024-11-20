extends CanvasLayer

signal fade_in_finished
signal fade_out_finished


func fade_in() -> void:
    fade_in_finished.emit()
    pass
    #$AnimationPlayer.play("fade_in")


func fade_out() -> void:
    fade_out_finished.emit()
    pass
    #$AnimationPlayer.play("fade_out")


func _on_animation_finished(anim_name: String) -> void:
    if anim_name == "fade_in":
        fade_in_finished.emit()
    elif anim_name == "fade_out":
        fade_out_finished.emit()
