extends EnemyEntity
class_name BossEntity

@export var current_phase: BossPhase.PHASE = BossPhase.PHASE.ENTRY
#TODO: add Transition phases between each path????
#TODO: for now just inheret the ENemyEntity's take damage
@onready var invulnerability: InvulnerabilityComponent = $InvulnerabilityComponent


func _ready() -> void:
	super._ready()  #TODO: figure out how to best conrtol the signal differences between Enemy and Boss...
	#TODO: make health initialization better (this just overwrites the health that the EnemyEntity gets
	self.health.set_current_health(400)
	self.health.max_health = 400


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
	# Boss attacks for phase one
	weapon.release_projectile(self, global_position, ProjectileType.TYPE.BOSS_BULLET, Vector2.DOWN)


func fire_missiles(_delta: float) -> void:
	# Boss attacks for phase two
	weapon.release_projectile(self, global_position, ProjectileType.TYPE.BOSS_MISSILE, Vector2.DOWN)
