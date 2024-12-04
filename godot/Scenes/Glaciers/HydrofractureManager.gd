extends Node2D
class_name HydrofractureManager

signal fracture_propagated(position: Vector2) #TODO: not used... yet?

var max_fracture_depth: int
var fracturing_coefficient: float


func propagate_fracture(mass_distribution: GlacierMassDistribution, glacier_map: TileMapLayer, position: Vector2, current_depth: int = 0) -> void:
    if current_depth > max_fracture_depth:
        return

    if mass_distribution.get_state(position) != GlacierCellState.STATE.INTACT:
        return

    mass_distribution.set_state(position, GlacierCellState.STATE.FRACTURED, glacier_map)

    var surrounding_cells: Array[Vector2i] = glacier_map.get_surrounding_cells(Vector2i(position))
    for cell in surrounding_cells:
        if randf() < fracturing_coefficient and mass_distribution.get_state(cell) == GlacierCellState.STATE.INTACT:
            propagate_fracture(mass_distribution, glacier_map, cell, current_depth + 1)
            fracture_propagated.emit(position)
