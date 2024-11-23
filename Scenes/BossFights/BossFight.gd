extends Node2D
class_name BossFight

var boss_entity: BossEntity
var active_path: BossPath

const ENTRY_PATH: String = "res://Scenes/BossFights/Paths/Entry.tscn"
@onready var entry_scene: PackedScene = preload(ENTRY_PATH)
var entry_path: BossPath

const PHASE_ONE_PATH: String = "res://Scenes/BossFights/Paths/PhaseOne.tscn"
@onready var phase_one_scene: PackedScene = preload(PHASE_ONE_PATH)
var phase_one_path: BossPath

const PHASE_TWO_PATH: String = "res://Scenes/BossFights/Paths/PhaseTwo.tscn"
@onready var phase_two_scene: PackedScene = preload(PHASE_TWO_PATH)
var phase_two_path: BossPath


func _ready() -> void:
    var boss_scene: PackedScene = preload("res://Scenes/BossFights/BossEntity.tscn")
    boss_entity = boss_scene.instantiate()
    ###
    #REMEMBER THIS NEXT LINE IS OK BECAUSE ONLY WHEN THE NODE IS ADDED TO THE SCENE AS A
    #CHILD DOES _READY() GET CALLED!!! NOT INSTANTIATE()!
    ###
    boss_entity.enemy_level = 5

    entry_path = add_path_to_scene(entry_scene, 45.0)
    phase_one_path = add_path_to_scene(phase_one_scene, 90.0)
    phase_two_path = add_path_to_scene(phase_two_scene, 50.0)

    add_child(boss_entity)  #TODO: HOLY HECK CHECK OUT _PROCESS FUNC

    self.active_path = entry_path

    #ONLY entry path uses path_complete sign
    entry_path.path_finished.connect(_on_entry_path_completed)
    boss_entity.health.health_two_third.connect(start_phase_two)
    boss_entity.health.health_one_third.connect(start_dying_phase)


#TODO: figure out how to do death from the entity to this scenen
#boss_entity.health.entity_died.connect(_on_boss_death)


func _process(_delta: float) -> void:
    #TODO: REFACTOR ALL THE PATHS TO JUST DO THIS OH MY GOD
    # INHERETING FROM THE PATH POSITION ACTUALLY CAUSES ISSUES WITH COLLISIONS
    # NEED TO INVESTIGATE WHY THAT IS, BUT ALSO THANK GOD WE DONT HAVE TO ADD THE ENEMIES AS CHILDREN
    # TO THE PATHFOLLOW NODES ANYMORE!!!!!
    if is_instance_valid(boss_entity):
        boss_entity.global_position = active_path.global_position  # HOLY HOLY HECK

    #TODO: boss entity getting freed should send a signal i think... I dont like this check here^^
    else:
        SignalBus.level_complete.emit()


#TODO: boss entity getting freed should send a signal i think... I dont like this check here^^


func add_path_to_scene(path_scene: PackedScene, speed: float) -> BossPath:
    var path_instance: Path2D = path_scene.instantiate()
    $BossMarker.add_child(path_instance)
    var path_follow: BossPath = path_instance.get_node("PathFollow2D")
    path_follow.path_speed = speed
    return path_follow


func _on_entry_path_completed() -> void:
    #TODO if the path isnt freed then this method gets called a ton cause the physics process is still running
    entry_path.queue_free()
    active_path = phase_one_path
    boss_entity.current_phase = BossPhase.PHASE.PHASE_ONE
    #TODO: this could just pass the boss entity? or its health??? KEY TO GETTING RID OF GROUPS!?!
    SignalBus.boss_entered.emit()


func start_phase_two() -> void:
    #TODO WHY WOuld it be in any other phase!!?!?
    if boss_entity.current_phase == BossPhase.PHASE.PHASE_ONE:
        active_path = phase_two_path
        boss_entity.current_phase = BossPhase.PHASE.PHASE_TWO


func start_dying_phase() -> void:
    #TODO WHY WOuld it be in any other phase!!?!? EWWWWWWWWWWWWWWW
    if boss_entity.current_phase == BossPhase.PHASE.PHASE_TWO:
        #TODO: for now active path stays the same
        #active_path = phase_two_path
        boss_entity.current_phase = BossPhase.PHASE.DYING
