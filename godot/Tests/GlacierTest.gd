extends Node2D
class_name GlacierTest

@export var hydrofracture_interval_seconds: float = 3.0
var glacier_surface: TileMapLayer
var glacier_cell_state: GlacierCellState.STATE
var timer: Timer = Timer.new()
const GLACIAL_PARTICLES_SCENE: PackedScene = preload("res://godot/Components/Particles/GlacialParticles.tscn")

func _ready() -> void:
    glacier_surface = get_child(0)
    initialize_glacier_cell()
    setup_timer()

func initialize_glacier_cell() -> void:
    glacier_cell_state = GlacierCellState.STATE.INTACT
    update_tile()

func setup_timer() -> void:
    timer.wait_time = hydrofracture_interval_seconds
    timer.timeout.connect(_on_timer_timeout)
    add_child(timer)
    timer.start()

func _on_timer_timeout() -> void:
    transition_glacier_cell_state()

func transition_glacier_cell_state() -> void:
    match glacier_cell_state:
        GlacierCellState.STATE.INTACT:
            glacier_cell_state = GlacierCellState.STATE.FRACTURED
        GlacierCellState.STATE.FRACTURED:
            glacier_cell_state = GlacierCellState.STATE.ICEBERG
            create_glacial_particles()
        _:
            timer.stop()
            pass
    update_tile()

func update_tile() -> void:
    var cell_position = Vector2i(0, 0)
    #TODO: This works now, study it and make it make sense for christs sake
    glacier_surface.set_cell(cell_position, 0, Vector2i(0, glacier_cell_state))

func create_glacial_particles() -> void:
    var particles_instance = GLACIAL_PARTICLES_SCENE.instantiate() as CPUParticles2D
    #particles_instance.position = glacier_surface.to_global(Vector2(0, 0))
    add_child(particles_instance)
