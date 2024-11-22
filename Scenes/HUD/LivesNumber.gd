extends Label

@onready var playerlives: int = GameStatsManager.lives


func _process(_delta: float) -> void:
    if playerlives:
        playerlives = GameStatsManager.lives
        text = str(playerlives)
