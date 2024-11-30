extends CPUParticles2D
class_name GlacierParticles

const SINGLE_FRAME_AVOIDANCE_BUFFER: float = 1 / 30
const TILE_SIZE: float = 8.0

func _ready() -> void:
    _initialize_particle_material()
    emitting = true
    one_shot = false

func _initialize_particle_material() -> void:
    self.lifetime = 5.0 + SINGLE_FRAME_AVOIDANCE_BUFFER
    self.amount = 10
    self.spread = 360.0
    self.initial_velocity_min = 10.0
    self.initial_velocity_max = 20.0
    self.scale_amount_min = 16.0  # Keep scale uniform (use tile size for snapping instead)
    self.scale_amount_max = 16.0
    self.gravity = Vector2(0, 4)

    # Create a gradient for icy colors
    self.color_ramp = Gradient.new()
    self.color_ramp.add_point(0.0, Color.AZURE)
    self.color_ramp.add_point(0.5, Color.STEEL_BLUE)
    self.color_ramp.add_point(1.0, Color.LIGHT_CYAN)
    self.color_ramp.set_interpolation_mode(Gradient.GRADIENT_INTERPOLATE_LINEAR)

    # Snapping Shader
    var shader: Shader = preload("res://Resources/Shaders/tile_resolution_particle_snapping.gdshader")
    var shader_material: ShaderMaterial = ShaderMaterial.new()
    shader_material.shader = shader
    shader_material.set_shader_parameter("grid_size", TILE_SIZE)  # Pass TILE_SIZE for snapping
    self.material = shader_material

    # Snap emission box to the grid
    _snap_emission_box_to_grid()

func _snap_emission_box_to_grid() -> void:
    var emission_half_extents = Vector2(TILE_SIZE, TILE_SIZE) / 2
    self.emission_rect_extents = emission_half_extents
