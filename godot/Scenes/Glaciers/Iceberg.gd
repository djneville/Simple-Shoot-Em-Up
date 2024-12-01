extends Node
class_name Iceberg

signal iceberg_created(position: Vector2)

var min_mass: int
var max_icebergs: int
var glacier_mass_distribution: GlacierMassDistribution
const iceberg_scene_path: String = "res://godot/Scenes/Glaciers/Iceberg.tscn"

func initialize(min_mass: int, max_icebergs: int, glacier_mass_distribution: GlacierMassDistribution) -> void:
    self.min_mass = min_mass
    self.max_icebergs = max_icebergs
    self.glacier_mass_distribution = glacier_mass_distribution

func identify_and_create_icebergs() -> int:
    var visited_cells: Dictionary = {}
    var new_icebergs_count = 0

    for position in glacier_mass_distribution.mass_distribution.keys():
        if visited_cells.has(position):
            continue
        if glacier_mass_distribution.get_state(position) != GlacierCellState.STATE.FRACTURED:
            continue

        var mass = perform_mass_flood_fill(position, visited_cells)
        if mass >= min_mass and new_icebergs_count < max_icebergs:
            create_iceberg(position)
            new_icebergs_count += 1

    return new_icebergs_count

func perform_mass_flood_fill(start_position: Vector2, visited: Dictionary) -> int:
    var stack = [start_position]
    var mass = 0

    while stack:
        var current_position = stack.pop_back()
        if visited.has(current_position):
            continue
        if glacier_mass_distribution.get_state(current_position) != GlacierCellState.STATE.FRACTURED:
            continue

        visited[current_position] = true
        mass += 1

        var surrounding_cells = glacier_mass_distribution.get_surrounding_cells(Vector2i(current_position))
        for adjacent_position in surrounding_cells:
            if not visited.has(adjacent_position) and glacier_mass_distribution.get_state(adjacent_position) == GlacierCellState.STATE.FRACTURED:
                stack.append(glacier_mass_distribution.map_to_world(adjacent_position))

    return mass

func create_iceberg(position: Vector2) -> void:
    glacier_mass_distribution.set_state(position, GlacierCellState.STATE.ICEBERG)
    iceberg_created.emit(position)
    # Additional iceberg creation logic can be handled via signal connections in the Glacier class
