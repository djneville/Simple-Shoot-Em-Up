extends RefCounted
class_name FractureRenderer

# Basic typed configuration variables
@export var cell_size: int = 16
@export var line_color: Color = Color(0.5, 0.5, 0.5)
@export var line_width: float = 2.0

# Dictionary for fractured cells: keys are String, values are bool
var fractured_cells: Dictionary = {}
# Dictionary for fracture lines: keys are String, values are Array[Vector2] (stored as Variant)
var fracture_lines: Dictionary = {}

func add_fractured_cell(position: Vector2i, glacier_map) -> void:
    var cell_key: String = str(position.x, "_", position.y)
    fractured_cells[cell_key] = true

    var neighbors: Array[Vector2i] = glacier_map.get_surrounding_cells(position)
    for neighbor in neighbors:
        var neighbor_key: String = str(neighbor.x, "_", neighbor.y)
        if fractured_cells.has(neighbor_key):
            _add_line_between_cells(position, neighbor)

func _add_line_between_cells(cell_a: Vector2i, cell_b: Vector2i) -> void:
    print("Adding line between ", cell_a, " and ", cell_b)
    var p1: Vector2 = Vector2(cell_a.x * cell_size + cell_size * 0.5, cell_a.y * cell_size + cell_size * 0.5)
    var p2: Vector2 = Vector2(cell_b.x * cell_size + cell_size * 0.5, cell_b.y * cell_size + cell_size * 0.5)

    var start_point: Vector2 = p1
    var end_point: Vector2 = p2
    if p2 < p1:
        start_point = p2
        end_point = p1

    var line_key: String = str(start_point.x, "_", start_point.y, "_", end_point.x, "_", end_point.y)

    var line_points: Array[Vector2] = [start_point, end_point]

    if not fracture_lines.has(line_key):
        fracture_lines[line_key] = line_points  # Stored as Variant, but was typed locally

func get_lines() -> Array:
    # fracture_lines.values() returns an Array of Variants,
    # each of which should be an Array[Vector2] as we stored it.
    return fracture_lines.values()
