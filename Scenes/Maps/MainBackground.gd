extends ParallaxBackground

@export var worldspeed: int = 150


func _ready() -> void:
    $MainParallax/EndOfMapMarker/VisibleOnScreenEnabler2D.screen_entered.connect(
        transition_to_boss_fight
    )


func _process(delta: float) -> void:
    self.scroll_base_offset.y += worldspeed * delta


func transition_to_boss_fight():
    SceneManager.change_scene(SceneManager.BOSS_FIGHT)
##TODO: then kill this test level??
