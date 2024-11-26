extends CPUParticles2D
class_name TrailingParticles

func _ready() -> void:
    _initialize_particle_material()
    emitting = true
    one_shot = false
    preprocess = 0.0

func _initialize_particle_material() -> void:
    self.lifetime = 2.0
    self.amount = 10
    self.spread = 0.0
    self.initial_velocity_max = 5
    self.initial_velocity_min = 5
    self.scale_amount_max = 10
    self.scale_amount_min = 10
    self.gravity = Vector2(0, 100)
    self.direction = Vector2(0, 1)

    self.color_ramp = Gradient.new()
    color_ramp.add_point(0.0, Color.ROYAL_BLUE)
    color_ramp.add_point(1.0, Color.AZURE)

    self.material = CanvasItemMaterial.new()
