extends Node
class_name HydrofractureController

signal fracture_propagated(position: Vector2)

var max_depth: int
var probability: float
var mass_distribution: GlacierMassDistribution

func initialize(max_depth: int, probability: float, mass_distribution: GlacierMassDistribution) -> void:
    self.max_depth = max_depth
    self.probability = probability
    self.mass_distribution = mass_distribution

func propagate_fracture(position: Vector2, current_depth: int = 0) -> void:
    if current_depth > max_depth:
        return

    if mass_distribution.get_state(position) != GlacierCellState.STATE.INTACT:
        return

    mass_distribution.set_state(position, GlacierCellState.STATE.FRACTURED)
    fracture_propagated.emit(position)

    var surrounding_cells = mass_distribution.tilemap.get_surrounding_cells(Vector2i(position))
    for cell in surrounding_cells:
        if randf() < probability and mass_distribution.get_state(cell) == GlacierCellState.STATE.INTACT:
            propagate_fracture(cell, current_depth + 1)
