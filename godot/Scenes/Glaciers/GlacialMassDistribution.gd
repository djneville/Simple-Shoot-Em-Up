extends Node2D
class_name GlacierMassDistribution

#TODO: ew, just ew...
var mass_distribution: Array = []

func initialize_mass_distribution(width: int, height: int, glacier_map: TileMapLayer) -> void:
    mass_distribution.resize(height)
    for y in range(height):
        mass_distribution[y] = []
        for x in range(width):
            var cell_position = Vector2(x, y)
            mass_distribution[y].append(GlacierCellState.STATE.INTACT)
            glacier_map.set_cell(cell_position, 0, Vector2i(0, GlacierCellState.STATE.INTACT))
            #TODO: at some point figure out if we can just set the cell_state via the atlas coords...?
            var atlas_coords = glacier_map.get_cell_atlas_coords(cell_position) # unused for now

func get_state(cell_position: Vector2) -> GlacierCellState.STATE:
    var x = int(cell_position.x)
    var y = int(cell_position.y)
    if y >= 0 and y < mass_distribution.size() and x >= 0 and x < mass_distribution[y].size():
        return mass_distribution[y][x]
    return GlacierCellState.STATE.NONE  # Default state if out of bounds????

func set_state(cell_position: Vector2, state: GlacierCellState.STATE, glacier_map: TileMapLayer) -> void:
    var x = int(cell_position.x)
    var y = int(cell_position.y)
    #TODO: ew again, this wouldnt have to even be checked if the mass_distribution array could be DIRECTLY EMBEDDED in the TileMapLayer...
    if y >= 0 and y < mass_distribution.size() and x >= 0 and x < mass_distribution[y].size():
        mass_distribution[y][x] = state
        glacier_map.set_cell(cell_position, 0, Vector2i(0, state))
