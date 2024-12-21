extends Node2D
class_name Glacier

const GLACIER_MAP_SCENE: PackedScene = preload("res://godot/Scenes/Glaciers/GlacierMap.tscn")
const GLACIAL_PARTICLES_SCENE: PackedScene = preload("res://godot/Components/Particles/GlacialParticles.tscn")

const GLACIER_MAP_WIDTH: int = 16 # this is in units of TILES!
const GLACIER_MAP_HEIGHT: int = 8

#TODO: i already forgot why these should be @exports vs consts... something about being able to edit them in the GUI i guess?
@export var hydrofracture_interval_seconds: float = 1.0
@export var fractures_per_cycle: int = 1
@export var max_fracture_depth: int = 10
# fracture_coefficient is a kind of "weight" on the rate of propagation (bigger the number -> faster/more fractures propagate)
@export var fracturing_coefficient: float = 0.4

#TODO: havent looked at messing with "mass" yet, it's part of the IcebergManager algorithm stuff
@export var min_iceberg_mass: int = 10
@export var max_active_icebergs: int = 20

var glacier_map: TileMapLayer
var glacier_mass_distribution: GlacierMassDistribution = GlacierMassDistribution.new()
var hydrofracture_manager: HydrofractureManager = HydrofractureManager.new()
var hydrofracture_timer: Timer = Timer.new()
var iceberg_manager: IcebergManager = IcebergManager.new()

const ICEBERG_GROUP: String = "Icebergs"
var active_icebergs_count: int = 0

func _ready() -> void:
    setup_glacier()
    setup_hydrofracture_timer()

func setup_glacier() -> void:
    glacier_map = GLACIER_MAP_SCENE.instantiate() as TileMapLayer
    glacier_mass_distribution.initialize_mass_distribution(GLACIER_MAP_WIDTH, GLACIER_MAP_HEIGHT, glacier_map)
    hydrofracture_manager.max_fracture_depth = self.max_fracture_depth
    hydrofracture_manager.fracturing_coefficient = self.fracturing_coefficient
    iceberg_manager.min_mass = self.min_iceberg_mass
    iceberg_manager.max_icebergs = self.max_active_icebergs
    iceberg_manager.iceberg_created.connect(_on_iceberg_created)
    add_child(glacier_map)

func setup_hydrofracture_timer() -> void:
    hydrofracture_timer.wait_time = hydrofracture_interval_seconds
    hydrofracture_timer.timeout.connect(_on_hydrofracture_cycle)
    add_child(hydrofracture_timer)
    hydrofracture_timer.start()

func _on_iceberg_created(_position: Vector2i) -> void:
    var particles_instance = GLACIAL_PARTICLES_SCENE.instantiate() as CPUParticles2D
    #TODO: this next line is a very ugly way to get Tile coordinates -> global coordinates (16x16 tiles)
    particles_instance.position = _position * 16
    add_child(particles_instance)

func _on_hydrofracture_cycle() -> void:
    var fractures_started = hydrofracture_manager.run_cycle(glacier_mass_distribution, glacier_map, fractures_per_cycle)
    if fractures_started == 0:
        return

    var new_icebergs = iceberg_manager.identify_and_create_icebergs(glacier_mass_distribution, glacier_map)
    active_icebergs_count += new_icebergs

    if active_icebergs_count >= max_active_icebergs:
        hydrofracture_timer.stop()

# New drawing function to visualize fractures
func _draw() -> void:
    var lines = hydrofracture_manager.fracture_renderer.get_lines()
    for line in lines:
        # line is [Vector2, Vector2]
        var start: Vector2 = line[0]
        var end: Vector2 = line[1]
        draw_line(start, end, hydrofracture_manager.fracture_renderer.line_color, hydrofracture_manager.fracture_renderer.line_width)

func _process(_delta: float) -> void:
    queue_redraw()
