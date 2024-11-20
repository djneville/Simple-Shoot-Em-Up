extends Node2D

var boss
var EntryPathFollow
var PathFollow1
var PathFollow2

var bossaddedto1 = false
var invulntransitionphase = false
var bossaddedto2 = false

var dying = false

var health = 400

signal uihealth


func _ready() -> void:
    boss = get_node("Entry Path/EntryPathFollow2D/Boss1")
    boss.damagesignal.connect(self.take_damage)
    boss.visible = true
    boss.state = 0
    boss.rotation = PI / 2

    EntryPathFollow = get_node("Entry Path/EntryPathFollow2D")
    EntryPathFollow.activated = true

    PathFollow1 = get_node("Pattern 1/1PathFollow2D")

    PathFollow2 = get_node("Pattern 2/2PathFollow2D")


func _process(_delta: float) -> void:
    if EntryPathFollow.complete and !bossaddedto1:
        EntryPathFollow.activated = false
        PathFollow1.activated = true
        EntryPathFollow.remove_child(boss)
        PathFollow1.add_child(boss)
        boss.state = 1
        boss.canshoot1 = true
        bossaddedto1 = true

    if health <= 200 and !invulntransitionphase:
        invulntransitionphase = true
        boss.boss_invulnerable()

    if (
        !bossaddedto2
        and boss.invulnerable
        and (
            snapped(PathFollow1.progress_ratio, 0.01) == .25
            or snapped(PathFollow1.progress_ratio, 0.01) == .75
        )
    ):
        boss.boss_revulnerable()
        PathFollow1.activated = false
        PathFollow2.activated = true
        PathFollow1.remove_child(boss)
        if snapped(PathFollow1.progress_ratio, 0.01) == .25:
            PathFollow2.progress_ratio = .75
        if snapped(PathFollow1.progress_ratio, 0.01) == .75:
            PathFollow2.progress_ratio = .25
        PathFollow2.add_child(boss)
        boss.state = 2
        bossaddedto2 = true

    if health <= 0 and !dying:
        print("dying")
        PathFollow2.activated = false
        boss.canshoot2 = false
        boss.canmissle = false
        boss.state = 4
        boss.BossAnims.play("death")
        GameStatsManager.score += 7500
        $GameCompleteTimer.start()
        dying = true


func take_damage(damage):
    health -= damage
    uihealth.emit(health)


func _on_game_complete_timer_timeout():
    #TODO: look at making a signal from the boss death to trigger in the Main.tscn scene
    GameStatsManager.level_complete.emit()
