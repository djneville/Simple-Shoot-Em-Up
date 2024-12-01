extends Node
class_name GlacierMassDistribution

var mass_distribution: Dictionary = {}
var tilemap: TileMapLayer

func initialize_mass_distribution(width: int, height: int, tilemap: TileMapLayer) -> void:
    self.tilemap = tilemap
    for y: int in range(height):
        for x: int in range(width):
            var cell_position = Vector2(x, y)
            mass_distribution[cell_position] = tilemap.get_cell_atlas_coords(cell_position)

func get_state(position: Vector2) -> int:
    return mass_distribution.get(position, GlacierCellState.STATE.NONE) #TODO: this doesnt do what you think it does

func set_state(position: Vector2, state: int) -> void:
    mass_distribution[position] = state
    tilemap.set_cell(position, state)
