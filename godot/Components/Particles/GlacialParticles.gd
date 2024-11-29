extends CPUParticles2D
class_name GlacierParticles

const SINGLE_FRAME_AVOIDANCE_BUFFER: float = 1 / 30
const TILE_SIZE: int = 4


func _ready() -> void:
    _initialize_particle_material()
    emitting = true
    one_shot = false
    _generate_snapped_emission_points()
    print("Particle System Ready - Emission Points: ", self.emission_points)
    queue_redraw()

func _initialize_particle_material() -> void:
    self.lifetime = 5.0 + SINGLE_FRAME_AVOIDANCE_BUFFER
    self.amount = 10
    self.spread = 360.0
    self.initial_velocity_min = 10.0
    self.initial_velocity_max = 20.0
    self.scale_amount_min = 16.0  # Match TILE_SIZE for visibility
    self.scale_amount_max = 32.0
    self.gravity = Vector2(0, 4)

    # Create a gradient for icy colors
    self.color_ramp = Gradient.new()
    self.color_ramp.add_point(0.0, Color.AZURE)
    self.color_ramp.add_point(0.5, Color.STEEL_BLUE)
    self.color_ramp.add_point(1.0, Color.LIGHT_CYAN)
    self.color_ramp.set_interpolation_mode(Gradient.GRADIENT_INTERPOLATE_LINEAR)

    # Assign ShaderMaterial with snapping shader
    var shader: Shader = preload("res://Resources/Shaders/tile_resolution_particle_snapping.gdshader")
    var shader_material: ShaderMaterial = ShaderMaterial.new()
    shader_material.shader = shader
    shader_material.set_shader_parameter("grid_size", Vector2(TILE_SIZE, TILE_SIZE))
    #dself.material = shader_material

func _generate_snapped_emission_points():
    self.emission_shape = CPUParticles2D.EMISSION_SHAPE_POINTS
    var rng = RandomNumberGenerator.new()
    rng.randomize()  # Ensure randomness
    var snapped_points = []

    for i in range(50):
        var x = rng.randf_range(-100, 100)
        var y = rng.randf_range(-20, 20)
        x = round(x / TILE_SIZE) * TILE_SIZE
        y = round(y / TILE_SIZE) * TILE_SIZE
        snapped_points.append(Vector2(x, y))

    self.emission_points = snapped_points
    print("Generated Emission Points: ", self.emission_points)
    queue_redraw()


#func _draw() -> void:
    #for point in emission_points:
        #draw_circle(point, 5, Color(1, 0, 0))  # Draw red circles
