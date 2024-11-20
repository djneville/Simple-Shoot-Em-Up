extends Label

@onready var playerscore: int = GameStatsManager.score


func _process(_delta: float) -> void:
    playerscore = GameStatsManager.score
    text = str(playerscore)
