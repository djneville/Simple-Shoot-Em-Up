extends CPUParticles2D
class_name TrailingParticles

func _ready() -> void:
    _initialize_particle_material()
    emitting = true
    one_shot = false

func _initialize_particle_material() -> void:
    #self.fixed_fps = 60
    self.lifetime = 1.0
    self.amount = 10
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
