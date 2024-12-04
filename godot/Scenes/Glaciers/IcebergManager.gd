extends Node
class_name IcebergManager

signal iceberg_created(position: Vector2i)

@export var min_mass: int
@export var max_icebergs: int

func identify_and_create_icebergs(mass_distribution: GlacierMassDistribution, glacier_map: TileMapLayer) -> int:
    var visited_cells: Dictionary = {}
    var new_icebergs_count: int = 0

    for y in range(mass_distribution.mass_distribution.size()):
        for x in range(mass_distribution.mass_distribution[y].size()):
            var position: Vector2i = Vector2i(x, y)

            if visited_cells.has(position):
                continue
            if mass_distribution.get_state(position) != GlacierCellState.STATE.FRACTURED:
                continue

            var mass: int = perform_mass_flood_fill(mass_distribution, glacier_map, position, visited_cells)
            if mass >= min_mass and new_icebergs_count < max_icebergs:
                create_iceberg(mass_distribution, position, glacier_map)
                new_icebergs_count += 1

    return new_icebergs_count

func perform_mass_flood_fill(mass_distribution: GlacierMassDistribution, glacier_map: TileMapLayer, start_position: Vector2i, visited: Dictionary) -> int:
    var stack: Array = [start_position]
    var mass: int = 0

    while stack:
        var current_position: Vector2i = stack.pop_back()

        if visited.has(current_position):
            continue
        if mass_distribution.get_state(current_position) != GlacierCellState.STATE.FRACTURED:
            continue

        visited[current_position] = true
        mass += 1

        var surrounding_cells: Array = glacier_map.get_surrounding_cells(current_position)
        for adjacent_position in surrounding_cells:
            if not visited.has(adjacent_position) and mass_distribution.get_state(adjacent_position) == GlacierCellState.STATE.FRACTURED:
                stack.append(adjacent_position)

    return mass

func create_iceberg(mass_distribution: GlacierMassDistribution, position: Vector2i, glacier_map: TileMapLayer) -> void:
    mass_distribution.set_state(position, GlacierCellState.STATE.ICEBERG, glacier_map)
    iceberg_created.emit(position)
    print("ICEBERG CREATED AT: ", position)
