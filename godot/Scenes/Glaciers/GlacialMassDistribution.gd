extends Node
class_name GlacierMassDistribution

class Tile:
    var state: int = GlacierCellState.STATE.INTACT

var mass_distribution: Array = []
var tilemap: TileMapLayer

func initialize_mass_distribution(width: int, height: int, tilemap: TileMapLayer) -> void:
    self.tilemap = tilemap
    mass_distribution.resize(height)
    for y in range(height):
        mass_distribution[y] = []
        for x in range(width):
            var cell_position = Vector2(x, y)
            var atlas_coords = tilemap.get_cell_atlas_coords(cell_position)
            var initial_state = GlacierCellState.STATE.INTACT  # You can set initial state based on atlas_coords if needed
            mass_distribution[y].append(Tile.new())
            mass_distribution[y][x].state = initial_state
            # Initialize the TileMapLayer with the initial state
            tilemap.set_cell(cell_position, initial_state)

func get_state(position: Vector2) -> int:
    var x = int(position.x)
    var y = int(position.y)
    if y >= 0 and y < mass_distribution.size() and x >= 0 and x < mass_distribution[y].size():
        return mass_distribution[y][x].state
    return GlacierCellState.STATE.NONE  # Default state if out of bounds????

func set_state(position: Vector2, state: int) -> void:
    var x = int(position.x)
    var y = int(position.y)
    if y >= 0 and y < mass_distribution.size() and x >= 0 and x < mass_distribution[y].size():
        mass_distribution[y][x].state = state
