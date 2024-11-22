extends Node

var score: int = 0
var lives: int = 3


func _ready() -> void:
    SignalBus.score_bonus.connect(_on_score_bonus)
    SignalBus.life_lost.connect(_on_life_lost)


#TODO: still wack that the connection method doesnt require argument with bind...
func _on_score_bonus(amount: int) -> void:
    score += amount


func _on_life_lost() -> void:
    lives -= 1
    score = 0
    SceneManager.change_scene(SceneManager.GAME_OVER)
