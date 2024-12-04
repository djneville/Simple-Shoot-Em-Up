extends Node
class_name HydrofractureController

signal fracture_propagated(position: Vector2)

var max_depth: int
var fracture_coefficient: float

func initialize(max_depth: int, fracture_coefficient: float) -> void:
    self.max_depth = max_depth
    self.fracture_coefficient = fracture_coefficient

func propagate_fracture(mass_distribution: GlacierMassDistribution, glacier_map: TileMapLayer, position: Vector2, current_depth: int = 0) -> void:
    if current_depth > max_depth:
        return

    if mass_distribution.get_state(position) != GlacierCellState.STATE.INTACT:
        return

    mass_distribution.set_state(position, GlacierCellState.STATE.FRACTURED, glacier_map)
    fracture_propagated.emit(position)

    var surrounding_cells: Array[Vector2i] = glacier_map.get_surrounding_cells(Vector2i(position))
    for cell in surrounding_cells:
        if randf() < fracture_coefficient and mass_distribution.get_state(cell) == GlacierCellState.STATE.INTACT:
            propagate_fracture(mass_distribution, glacier_map, cell, current_depth + 1)
