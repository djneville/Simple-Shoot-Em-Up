extends Node2D
class_name Glacier

# Grid Configuration
@export var glacier_width: int = 32
@export var glacier_height: int = 48
@export var initial_accumulation_depth: int = 10

# Crack Propagation Configuration
@export var hydrofracture_interval_seconds: float = 2.0
@export var fractures_per_cycle: int = 2
@export var fracture_spread_probability: float = 0.3
@export var max_fracture_depth: int = 10

# Iceberg Formation Configuration
@export var min_iceberg_mass: int = 10
@export var max_active_icebergs: int = 20

# Glacier Cell States
enum GlacierCellState {
    NONE = -1,
    INTACT = 1,
    FRACTURED = 2,
    ICEBERG = 3
}

# Constants for Directions
const ADJACENT_DIRECTIONS = [
    Vector2(1, 0),  # Right
    Vector2(-1, 0), # Left
    Vector2(0, 1),  # Down
    Vector2(0, -1)  # Up
]

# Nodes
var glacier_surface: TileMap
var hydrofracture_timer: Timer

# Active Icebergs Count
var active_icebergs_count: int = 0

# Glacier Cell States Mapping
var glacier_mass_distribution: Dictionary = {}

# Groups
const ICEBERG_GROUP = "Icebergs"

# Signals
signal iceberg_formed(position: Vector2)

func _ready() -> void:
    initialize_glacier_surface()
    align_glacier_to_viewport()
    setup_hydrofracture_timer()
    populate_initial_accumulation_zone()
    iceberg_formed.connect(_on_iceberg_formed)

# Initialize the TileMap for glacier visualization
func initialize_glacier_surface() -> void:
    glacier_surface = TileMap.new()
    glacier_surface.cell_size = Vector2(8, 8)
    glacier_surface.tile_set = create_glacier_tile_set()
    add_child(glacier_surface)

# Create the TileSet for visualizing glacier states
func create_glacier_tile_set() -> TileSet:
    var glacier_tileset: TileSet = TileSet.new()
    var state_colors: Dictionary = {
        GlacierCellState.INTACT: Color(1, 1, 1),          # White for intact ice
        GlacierCellState.FRACTURED: Color(0.6, 0.6, 0.6), # Gray for fractures
        GlacierCellState.ICEBERG: Color(0.8, 0.9, 1)       # Light Blue for icebergs
    }

    for state in state_colors.keys():
        var color: Color = state_colors[state]

        var image: Image = Image.new()
        image.create(1, 1, false, Image.FORMAT_RGBA8)
        image.lock()
        image.set_pixel(0, 0, color)
        image.unlock()

        var texture: ImageTexture = ImageTexture.new()
        texture.create_from_image(image)

        glacier_tileset.create_tile(state)
        glacier_tileset.tile_set_texture(state, texture)

    return glacier_tileset

# Align the glacier map to fit the viewport dimensions
func align_glacier_to_viewport() -> void:
    var viewport_size: Vector2 = get_viewport().size
    glacier_surface.cell_size = Vector2(viewport_size.x / glacier_width, viewport_size.y / glacier_height)
    glacier_surface.position = Vector2.ZERO

# Configure the timer for periodic hydrofracture events
func setup_hydrofracture_timer() -> void:
    hydrofracture_timer = Timer.new()
    hydrofracture_timer.wait_time = hydrofracture_interval_seconds
    hydrofracture_timer.autostart = true
    hydrofracture_timer.one_shot = false
    hydrofracture_timer.timeout.connect(_on_hydrofracture_cycle)
    add_child(hydrofracture_timer)

# Populate the glacier with initial intact ice
func populate_initial_accumulation_zone() -> void:
    for row in range(initial_accumulation_depth):
        for column in range(glacier_width):
            var cell_position: Vector2 = Vector2(column, row)
            set_cell_state(cell_position, GlacierCellState.INTACT)

# Set the state of a specific cell
func set_cell_state(position: Vector2, state: GlacierCellState) -> void:
    glacier_surface.set_cellv(position, state)
    glacier_mass_distribution[position] = state

# Handle the hydrofracture cycle
func _on_hydrofracture_cycle() -> void:
    var fracture_zones: Array = find_fracture_zones()
    if fracture_zones.is_empty():
        hydrofracture_timer.stop()
        return

    fracture_zones.shuffle()
    var selected_fracture_starts: Array = fracture_zones.slice(0, min(fractures_per_cycle, fracture_zones.size()))

    for fracture_start in selected_fracture_starts:
        propagate_fracture(fracture_start, 0)

    identify_and_create_icebergs()

# Find potential fracture zones along the glacier edge
func find_fracture_zones() -> Array:
    var fracture_zones: Array = []
    for y in range(glacier_height):
        for x in range(glacier_width):
            var cell_position: Vector2 = Vector2(x, y)
            if is_fracture_zone(cell_position):
                fracture_zones.append(cell_position)
    return fracture_zones

# Check if a cell is in a fracture zone
func is_fracture_zone(position: Vector2) -> bool:
    var current_state: int = glacier_mass_distribution.get(position, GlacierCellState.NONE)
    if current_state not in [GlacierCellState.INTACT, GlacierCellState.FRACTURED]:
        return false

    for direction in ADJACENT_DIRECTIONS:
        var adjacent_position: Vector2 = position + direction
        if not is_within_grid(adjacent_position):
            continue
        var adjacent_state: int = glacier_mass_distribution.get(adjacent_position, GlacierCellState.NONE)
        if adjacent_state == GlacierCellState.NONE:
            return true

    return false

# Ensure a position is within the glacier grid boundaries
func is_within_grid(position: Vector2) -> bool:
    return position.x >= 0 and position.x < glacier_width and position.y >= 0 and position.y < glacier_height

# Propagate a fracture recursively
func propagate_fracture(position: Vector2, current_depth: int) -> void:
    if current_depth > max_fracture_depth:
        return

    if not is_valid_fracture_position(position):
        return

    # Mark the cell as fractured
    set_cell_state(position, GlacierCellState.FRACTURED)

    for direction in ADJACENT_DIRECTIONS:
        var adjacent_position: Vector2 = position + direction
        if randf() < fracture_spread_probability:
            propagate_fracture(adjacent_position, current_depth + 1)

# Validate if the fracture can propagate to the position
func is_valid_fracture_position(position: Vector2) -> bool:
    var current_state: int = glacier_mass_distribution.get(position, GlacierCellState.NONE)
    return current_state != GlacierCellState.NONE and current_state != GlacierCellState.ICEBERG and is_within_grid(position)

# Identify and form icebergs from fractured zones
func identify_and_create_icebergs() -> void:
    var visited_cells: Dictionary = {}
    var new_icebergs_count: int = 0

    for y in range(glacier_height):
        for x in range(glacier_width):
            var position: Vector2 = Vector2(x, y)
            if visited_cells.has(position):
                continue

            var current_state: int = glacier_mass_distribution.get(position, GlacierCellState.NONE)
            if current_state not in [GlacierCellState.INTACT, GlacierCellState.FRACTURED]:
                continue

            var iceberg_mass: int = perform_mass_flood_fill(position, visited_cells)
            if iceberg_mass >= min_iceberg_mass and active_icebergs_count < max_active_icebergs:
                transform_to_iceberg(position)
                new_icebergs_count += 1

    active_icebergs_count += new_icebergs_count

# Perform a flood fill to calculate the mass of a connected ice region
func perform_mass_flood_fill(start_position: Vector2, visited: Dictionary) -> int:
    var stack: Array = [start_position]
    var mass: int = 0
    var walkable_cells: Dictionary = {start_position: true}

    while stack.size() > 0:
        var current_position: Vector2 = stack.pop_back()

        if visited.has(current_position):
            continue

        if not is_within_grid(current_position):
            continue

        var current_state: int = glacier_mass_distribution.get(current_position, GlacierCellState.NONE)
        if current_state not in [GlacierCellState.INTACT, GlacierCellState.FRACTURED]:
            continue

        visited[current_position] = true
        mass += 1

        for direction in ADJACENT_DIRECTIONS:
            var adjacent_position: Vector2 = current_position + direction
            if is_fracture_zone(adjacent_position) and not walkable_cells.has(adjacent_position):
                walkable_cells[adjacent_position] = true
                stack.append(adjacent_position)

    return mass

# Transform a connected region into an iceberg
func transform_to_iceberg(start_position: Vector2) -> void:
    var stack: Array = [start_position]

    while stack.size() > 0:
        var current_position: Vector2 = stack.pop_back()

        if glacier_mass_distribution.get(current_position, GlacierCellState.NONE) != GlacierCellState.FRACTURED:
            continue

        # Convert the cell to an iceberg
        set_cell_state(current_position, GlacierCellState.ICEBERG)
        add_iceberg_to_group(current_position)

        for direction in ADJACENT_DIRECTIONS:
            var adjacent_position: Vector2 = current_position + direction
            if glacier_mass_distribution.get(adjacent_position, GlacierCellState.NONE) == GlacierCellState.FRACTURED:
                stack.append(adjacent_position)

    # Emit signal for iceberg formation
    emit_signal("iceberg_formed", start_position)

# Add the iceberg to the Icebergs group for management
func add_iceberg_to_group(position: Vector2) -> void:
    var iceberg = create_iceberg_node(position)
    add_child(iceberg)
    iceberg.add_to_group(ICEBERG_GROUP)

# Create an Iceberg node (Assuming Iceberg is a predefined scene)
func create_iceberg_node(position: Vector2) -> Node2D:
    var iceberg_scene = preload("res://godot/Scenes/Glaciers/Iceberg.tscn")  # Replace with your Iceberg scene path
    var iceberg_instance = iceberg_scene.instance()
    iceberg_instance.position = glacier_surface.map_to_world(position)
    return iceberg_instance

# Handle iceberg formation (e.g., play animation, update UI)
func _on_iceberg_formed(position: Vector2) -> void:
    # Implement any additional logic when an iceberg is formed
    print("Iceberg formed at: ", position)
