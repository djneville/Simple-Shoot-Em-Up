extends Node2D
class_name BossFight

var boss_entity: BossEntity
const BOSS_SCENE: String = "res://godot/Entities/Bosses/BossEntity.tscn"
var boss_scene: PackedScene = preload(BOSS_SCENE)

const ENTRY_PATH: String = "res://godot/Scenes/BossPaths/Entry.tscn"
@onready var entry_scene: PackedScene = preload(ENTRY_PATH)
var entry_path: BossPath

const PHASE_ONE_PATH: String = "res://godot/Scenes/BossPaths/PhaseOne.tscn"
@onready var phase_one_scene: PackedScene = preload(PHASE_ONE_PATH)
var phase_one_path: BossPath

const PHASE_TWO_PATH: String = "res://godot/Scenes/BossPaths/PhaseTwo.tscn"
@onready var phase_two_scene: PackedScene = preload(PHASE_TWO_PATH)
var phase_two_path: BossPath

var active_path: BossPath

func _ready() -> void:
    boss_entity = boss_scene.instantiate() as BossEntity
    ###
    #REMEMBER THIS NEXT LINE IS OK BECAUSE ONLY WHEN THE NODE IS ADDED TO THE SCENE AS A
    #CHILD DOES _READY() GET CALLED!!! INSTANTIATE() just sets the class attributes
    ###
    boss_entity.enemy_level = 5 #TODO: still horrible.

    entry_path = add_path_to_scene(entry_scene, 45.0)
    phase_one_path = add_path_to_scene(phase_one_scene, 90.0)
    phase_two_path = add_path_to_scene(phase_two_scene, 50.0)


    self.active_path = entry_path

    add_child(boss_entity)  #TODO: HOLY HECK CHECK OUT _PROCESS FUNC


    #ONLY entry path uses path_complete sign
    entry_path.path_finished.connect(_on_entry_path_completed)
    boss_entity.health.health_two_third.connect(start_phase_two)
    boss_entity.health.health_one_third.connect(start_dying_phase)


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
    active_path = phase_two_path
    boss_entity.current_phase = BossPhase.PHASE.PHASE_TWO


func start_dying_phase() -> void:
    #TODO: for now active path stays the same
    #active_path = phase_two_path
    boss_entity.current_phase = BossPhase.PHASE.DYING
