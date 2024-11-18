extends Marker2D

@export var enemy_level: int = 2
@export var path: Path2D = null
@onready var path_resource = preload("res://Scenes/Enemies/Paths/DiagonalRight.tscn")


func _ready():
    self.path = path_resource.instantiate()

func _process(delta: float) -> void:
    #TODO: this is parallaxes fault, the 100 comes from paralax pretty much
    position += Vector2.DOWN * 100 * delta
