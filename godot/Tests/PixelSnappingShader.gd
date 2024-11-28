extends Sprite2D
class_name PixelSnappingOnRotation

# Shader parameters
@export var rotation_steps: int = 8  # Number of discrete rotations (e.g., 8 for 45-degree steps)
@export var texture_size: Vector2 = Vector2(16, 16)  # Size of the sprite texture

func _ready() -> void:
    setup_shader()

func setup_shader() -> void:
    # Create the shader
    var shader: Shader = preload("res://Resources/Shaders/pixel_snapping_on_rotation.gdshader")
    # Create and configure the ShaderMaterial
    var shader_material = ShaderMaterial.new()
    shader_material.shader = shader
    shader_material.set_shader_parameter("rotation_steps", rotation_steps)
    shader_material.set_shader_parameter("texture_size", texture_size)
    self.material = shader_material

func update_rotation(input_vector: Vector2) -> void:
    if input_vector.length() > 0:
        rotation = input_vector.angle()
        + PI/2
        var shader_material = self.material as ShaderMaterial
        shader_material.set_shader_parameter("rotation", rotation)
