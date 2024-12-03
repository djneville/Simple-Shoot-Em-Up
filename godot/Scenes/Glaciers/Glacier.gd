extends Node2D
class_name Glacier

@export var glacier_width: int = 16
@export var glacier_height: int = 8

@export var hydrofracture_interval_seconds: float = 2.0
@export var fractures_per_cycle: int = 2
@export var fracture_spread_probability: float = 0.3
@export var max_fracture_depth: int = 10

@export var min_iceberg_mass: int = 10
@export var max_active_icebergs: int = 20

const GLACIER_MAP_SCENE: String = "res://godot/Scenes/Glaciers/GlacierMap.tscn"

var glacier_surface: TileMapLayer
var glacier_mass_distribution: GlacierMassDistribution
var hydrofracture_controller: HydrofractureController
var iceberg_manager: Iceberg

const ICEBERG_GROUP: String = "Icebergs"

var active_icebergs_count: int = 0

signal iceberg_formed(position: Vector2)

func _ready() -> void:
    load_glacier_map()
    setup_mass_distribution()
    setup_hydrofracture_controller()
    setup_iceberg_manager()
    setup_hydrofracture_timer()
    connect_signals()

func load_glacier_map() -> void:
    var glacier_map_scene: PackedScene = preload(GLACIER_MAP_SCENE)
    glacier_surface = glacier_map_scene.instantiate() as TileMapLayer
    add_child(glacier_surface)

func setup_mass_distribution() -> void:
    glacier_mass_distribution = GlacierMassDistribution.new()
    add_child(glacier_mass_distribution)
    glacier_mass_distribution.initialize_mass_distribution(glacier_width, glacier_height, glacier_surface)

func setup_hydrofracture_controller() -> void:
    hydrofracture_controller = HydrofractureController.new()
    add_child(hydrofracture_controller)
    hydrofracture_controller.initialize(max_fracture_depth, fracture_spread_probability, glacier_mass_distribution)

func setup_iceberg_manager() -> void:
    iceberg_manager = Iceberg.new()
    add_child(iceberg_manager)
    iceberg_manager.initialize(min_iceberg_mass, max_active_icebergs, glacier_mass_distribution)

func setup_hydrofracture_timer() -> void:
    var hydrofracture_timer: Timer = Timer.new()
    hydrofracture_timer.wait_time = hydrofracture_interval_seconds
    hydrofracture_timer.autostart = true
    hydrofracture_timer.one_shot = false
    hydrofracture_timer.timeout.connect(_on_hydrofracture_cycle)
    add_child(hydrofracture_timer)

func connect_signals() -> void:
    hydrofracture_controller.fracture_propagated.connect(_on_fracture_propagated)
    iceberg_manager.iceberg_created.connect(_on_iceberg_created)

func _on_hydrofracture_cycle() -> void:
    var fracture_zones: Array[Vector2i] = find_fracture_zones()
    if fracture_zones.is_empty():
        return  # Keep the timer running for future attempts

    fracture_zones.shuffle()
    var selected_fracture_starts: Array[Vector2i] = fracture_zones.slice(0, min(fractures_per_cycle, fracture_zones.size()))

    for fracture_start: Vector2i in selected_fracture_starts:
        hydrofracture_controller.propagate_fracture(fracture_start)

    var new_icebergs: int = iceberg_manager.identify_and_create_icebergs()
    active_icebergs_count += new_icebergs

    if active_icebergs_count >= max_active_icebergs:
        # Optionally stop the timer if maximum icebergs are reached
        # hydrofracture_timer.stop()
        pass

func find_fracture_zones() -> Array[Vector2i]:
    var fracture_zones: Array[Vector2i] = []
    for y: int in range(glacier_height):
        for x: int in range(glacier_width):
            var cell_position: Vector2i = Vector2i(x, y)
            if is_fracture_zone(cell_position):
                fracture_zones.append(cell_position)
    return fracture_zones

func is_fracture_zone(position: Vector2i) -> bool:
    var current_state: int = glacier_mass_distribution.get_state(position)
    if current_state not in [GlacierCellState.STATE.INTACT, GlacierCellState.STATE.FRACTURED]:
        return false

    var surrounding_cells: Array[Vector2i] = glacier_surface.get_surrounding_cells(position)
    for cell: Vector2i in surrounding_cells:
        var adjacent_state: int = glacier_mass_distribution.get_state(cell)
        if adjacent_state == GlacierCellState.STATE.NONE:
            return true

    return false

func _on_fracture_propagated(position: Vector2) -> void:
    # Optional: Handle individual fracture propagation events?? (ITS ALL DONE IN THE HYDRO DCONTROLLER
    pass

func _on_iceberg_created(position: Vector2) -> void:
    create_iceberg_node(position)

func create_iceberg_node(position: Vector2) -> void:
    var iceberg_scene: PackedScene = preload("res://godot/Scenes/Glaciers/Iceberg.tscn")
    var iceberg_instance: Node2D = iceberg_scene.instantiate() as Node2D
    iceberg_instance.position = glacier_surface.to_global(Vector2i(position))
    add_child(iceberg_instance)
    iceberg_instance.add_to_group(ICEBERG_GROUP)
    emit_signal("iceberg_formed", position)
