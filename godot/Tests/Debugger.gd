extends Node2D

var emission_points: Array = []

func asdset_emission_points(points: Array) -> void:
    emission_points = points

func _draw() -> void:
    for point in emission_points:
        draw_circle(point, 5, Color(1, 0, 0))  # Draw red circles
