extends Node
class_name Iceberg

signal iceberg_created(position: Vector2i)

# Configuration variables
var min_mass: int
var max_icebergs: int
var glacier_mass_distribution: GlacierMassDistribution

const ICEBERG_SCENE_PATH: String = "res://godot/Scenes/Glaciers/Iceberg.tscn"

# Initialize the Iceberg manager
func initialize(min_mass: int, max_icebergs: int, glacier_mass_distribution: GlacierMassDistribution) -> void:
    self.min_mass = min_mass
    self.max_icebergs = max_icebergs
    self.glacier_mass_distribution = glacier_mass_distribution

# Identify and create icebergs based on fractured cells
func identify_and_create_icebergs() -> int:
    var visited_cells: Dictionary = {}
    var new_icebergs_count: int = 0

    for y in range(glacier_mass_distribution.mass_distribution.size()):
        for x in range(glacier_mass_distribution.mass_distribution[y].size()):
            var position: Vector2i = Vector2i(x, y)

            if visited_cells.has(position):
                continue
            if glacier_mass_distribution.get_state(position) != GlacierCellState.STATE.FRACTURED:
                continue

            var mass: int = perform_mass_flood_fill(position, visited_cells)
            if mass >= min_mass and new_icebergs_count < max_icebergs:
                create_iceberg(position)
                new_icebergs_count += 1

    return new_icebergs_count

# Perform flood fill to calculate the mass of connected fractured cells
func perform_mass_flood_fill(start_position: Vector2i, visited: Dictionary) -> int:
    var stack: Array = [start_position]
    var mass: int = 0

    while stack:
        var current_position: Vector2i = stack.pop_back()

        if visited.has(current_position):
            continue
        if glacier_mass_distribution.get_state(current_position) != GlacierCellState.STATE.FRACTURED:
            continue

        visited[current_position] = true
        mass += 1

        var surrounding_cells: Array = glacier_mass_distribution.tilemap.get_surrounding_cells(current_position)
        for adjacent_position in surrounding_cells:
            if not visited.has(adjacent_position) and glacier_mass_distribution.get_state(adjacent_position) == GlacierCellState.STATE.FRACTURED:
                stack.append(adjacent_position)

    return mass

# Create an iceberg at the specified position
func create_iceberg(position: Vector2i) -> void:
    glacier_mass_distribution.set_state(position, GlacierCellState.STATE.ICEBERG)
    emit_signal("iceberg_created", position)
    # Additional iceberg creation logic can be handled via signal connections in the Glacier class
