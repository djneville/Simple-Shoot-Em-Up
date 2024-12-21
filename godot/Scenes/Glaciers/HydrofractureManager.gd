extends Node2D
class_name HydrofractureManager

signal fracture_propagated(position: Vector2)

var max_fracture_depth: int
var fracturing_coefficient: float

var fracture_renderer: FractureRenderer = FractureRenderer.new()

func run_cycle(glacier_mass_distribution: GlacierMassDistribution, glacier_map: TileMapLayer, fractures_per_cycle: int) -> int:
    var fracture_zones = find_fracture_zones(glacier_mass_distribution, glacier_map)
    if fracture_zones.is_empty():
        return 0

    fracture_zones.shuffle()
    var selected_fracture_starts = fracture_zones.slice(0, min(fractures_per_cycle, fracture_zones.size()))

    for fracture_start_coordinates in selected_fracture_starts:
        propagate_fracture(glacier_mass_distribution, glacier_map, fracture_start_coordinates)
    return selected_fracture_starts.size()

func find_fracture_zones(glacier_mass_distribution: GlacierMassDistribution, glacier_map: TileMapLayer) -> Array[Vector2i]:
    var fracture_zones: Array[Vector2i] = []
    var used_rect = glacier_map.get_used_rect()
    var bottom_row = used_rect.size.y - 1
    for x in range(used_rect.size.x):
        var cell_position = Vector2i(x, bottom_row)
        if is_fracture_zone(cell_position, glacier_mass_distribution, glacier_map):
            fracture_zones.append(cell_position)
    return fracture_zones

func is_fracture_zone(position: Vector2i, glacier_mass_distribution: GlacierMassDistribution, glacier_map: TileMapLayer) -> bool:
    var current_state = glacier_mass_distribution.get_state(position)
    if current_state not in [GlacierCellState.STATE.INTACT, GlacierCellState.STATE.FRACTURED]:
        return false

    var surrounding_cells = glacier_map.get_surrounding_cells(position)
    for cell in surrounding_cells:
        var adjacent_state = glacier_mass_distribution.get_state(cell)
        if adjacent_state == GlacierCellState.STATE.NONE:
            return true

    return false

func propagate_fracture(mass_distribution: GlacierMassDistribution, glacier_map: TileMapLayer, position: Vector2, current_depth: int = 0) -> void:
    if current_depth > max_fracture_depth:
        return

    if mass_distribution.get_state(position) != GlacierCellState.STATE.INTACT:
        return

    # Set fractured state
    mass_distribution.set_state(position, GlacierCellState.STATE.FRACTURED, glacier_map)
    # Update the fracture renderer with this new fractured cell
    fracture_renderer.add_fractured_cell(Vector2i(position), glacier_map)

    fracture_propagated.emit(position)

    var surrounding_cells: Array[Vector2i] = glacier_map.get_surrounding_cells(Vector2i(position))
    for cell in surrounding_cells:
        if randf() < fracturing_coefficient and mass_distribution.get_state(cell) == GlacierCellState.STATE.INTACT:
            propagate_fracture(mass_distribution, glacier_map, cell, current_depth + 1)
