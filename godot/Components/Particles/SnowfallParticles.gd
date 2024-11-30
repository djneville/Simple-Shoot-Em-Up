extends CPUParticles2D
class_name SnowfallParticles

const TILE_SIZE: float = 4.0
const SNOW_SCALE_START: float = 32.0  # Start size in pixels
const SNOW_SCALE_END: float = 2.0     # End size in pixels

func _ready() -> void:
    _initialize_particle_material()
    emitting = true
    one_shot = false

func _initialize_particle_material() -> void:
    self.lifetime = 2.0
    self.amount = 130.0
    self.spread = 90.0
    self.direction = Vector2(0, 1)
    self.initial_velocity_min = 5.0
    self.initial_velocity_max = 20.0
    self.gravity = Vector2(0.0, 1)
    self.scale_amount_min = 1.0  # Keep base scale as unit size
    self.scale_amount_max = 1.0

    #self.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE_SURFACE
    #self.emission_sphere_radius = get_viewport().size / 2.0 # EXTENTS IS A kind of radius for a rectangle, not the actual WxH, half of that

    self.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
    self.emission_rect_extents = get_viewport().size / 2.0 # EXTENTS IS A kind of radius for a rectangle, not the actual WxH, half of that

    self.color_ramp = Gradient.new()
    self.color_ramp.add_point(0.0, Color(Color.WHITE, 0.9))
    self.color_ramp.add_point(0.999, Color(Color.WHITE, 0.0)) # THIS IS CRAZY, 1.0 is NOT ALLOWED HERE!!! (for the shader's COLOR alpha to serve as lifetime)
    self.color_ramp.set_interpolation_mode(Gradient.GRADIENT_INTERPOLATE_LINEAR)

    var shader: Shader = preload("res://Resources/Shaders/snow_particle_shader.gdshader")
    var shader_material: ShaderMaterial = ShaderMaterial.new()
    shader_material.shader = shader
    shader_material.set_shader_parameter("scale_start", SNOW_SCALE_START)
    shader_material.set_shader_parameter("scale_end", SNOW_SCALE_END)
    shader_material.set_shader_parameter("grid_size", TILE_SIZE)
    self.material = shader_material
