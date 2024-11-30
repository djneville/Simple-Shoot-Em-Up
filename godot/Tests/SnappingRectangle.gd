extends Node2D
class_name SnappingRectangle

@export var rect_size: Vector2 = Vector2(16, 16)  # Size of the rectangle
@export var rect_color: Color = Color.CADET_BLUE    # Color of the rectangle

func _ready() -> void:
    var color_rect = ColorRect.new()
    color_rect.size = rect_size
    color_rect.color = rect_color
    color_rect.position = Vector2.ZERO
    add_child(color_rect)
    var shader = preload("res://Resources/Shaders/tile_resolution_particle_snapping.gdshader")
    var shader_material = ShaderMaterial.new()
    shader_material.shader = shader
    color_rect.material = shader_material
