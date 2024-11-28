extends CPUParticles2D
class_name TrailingParticles

const SINGLE_FRAME_AVOIDANCE_BUFFER: float = 1 / 30

func _ready() -> void:
    _initialize_particle_material()
    emitting = true
    one_shot = false

func _initialize_particle_material() -> void:
    self.lifetime = 1.0  + SINGLE_FRAME_AVOIDANCE_BUFFER
    self.amount = 100
    self.spread = 0.0
    self.initial_velocity_max = 1.0
    self.initial_velocity_min = 1.0
    self.scale_amount_max = 1
    self.scale_amount_min = 1
    self.gravity = Vector2(0, 2)
    self.direction = Vector2(0, 1)

    self.color_ramp = Gradient.new()
    color_ramp.add_point(0.0, Color.ROYAL_BLUE)
    color_ramp.add_point(1.0, Color.AZURE)
    color_ramp.set_interpolation_mode(Gradient.GRADIENT_INTERPOLATE_LINEAR)

    self.material = CanvasItemMaterial.new()
    _emission_shape_settings()


func _emission_shape_settings():
    self.emission_shape = CPUParticles2D.EMISSION_SHAPE_POINTS
    self.emission_points = [
        Vector2(-2, 0),  # Left-most point
        Vector2(-1, 0),  # Left-middle point
        Vector2(-0, 0),   # Right-middle point
        Vector2(1, 0),    # Right-most point
        Vector2(2, 0)
    ]
