extends Node2D
class_name TestScene

const MOVE_SPEED = 200.0

var camera: Camera2D

func _ready() -> void:
    center_viewport()

func center_viewport() -> void:
    camera = Camera2D.new()
    camera.position = Vector2.ZERO
    add_child(camera)

func _process(delta: float) -> void:
    var input_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
    for child in get_children():
        if child != camera:
            child.position += input_vector * MOVE_SPEED * delta
