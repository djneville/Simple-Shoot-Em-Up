extends ParallaxBackground

@export var worldspeed: int = 100

signal reached_top

#TODO: figure out how to get the height of the tilemap
const TOP_THRESHOLD: int = 92000


func _process(delta: float) -> void:
    self.scroll_base_offset.y += worldspeed * delta
    if scroll_base_offset.y >= TOP_THRESHOLD:
        reached_top.emit()
        SceneManager.change_scene(SceneManager.BOSS_FIGHT)
        ##TODO: then kill this test level??
