extends EnemyEntity
class_name BossEntity

const BOSS_POINTS: int = 7500

@export var current_phase: BossPhase.PHASE = BossPhase.PHASE.ENTRY
@onready var invulnerability: InvulnerabilityComponent = $InvulnerabilityComponent


func _ready() -> void:
    super._ready()  #TODO: figure out how to best conrtol the signal differences between Enemy and Boss...
    #TODO: make health initialization better (this just overwrites the health that the EnemyEntity gets
    self.points = BOSS_POINTS
    self.health.set_current_health(40)
    self.health.max_health = 40


func _process(delta: float) -> void:
    match current_phase:
        BossPhase.PHASE.ENTRY:
            pass  # No weapon behavior during entry
        BossPhase.PHASE.PHASE_ONE:
            fire_bullets(delta)
        BossPhase.PHASE.PHASE_TWO:
            fire_missiles(delta)
        BossPhase.PHASE.DYING:
            fire_bullets(delta)
            fire_missiles(delta)


func fire_bullets(_delta: float) -> void:
    var gun: Gun = upgrade_component.get_node("Gun")
    if gun:
        gun.fire(self, position, Vector2.DOWN)


func fire_missiles(_delta: float) -> void:
    var missile_launcher: MissileLauncher = upgrade_component.get_node("MissileLauncher")
    if missile_launcher:
        missile_launcher.fire(self, position, Vector2.DOWN)


# EnemyEntity Override functions
func take_damage(damage: int):
    if current_phase != BossPhase.PHASE.ENTRY:
        super.take_damage(damage)


func _on_animation_finished(anim_name: String) -> void:
    if anim_name == "Explosion":
        GameStatsManager.score += self.points
        SignalBus.score_updated.emit()
        self.give_points.emit(self.points)
        SignalBus.level_complete.emit()
#TODO: WHEN TO GREE THIS!?? (SET PROCESS TO FALSE???!
