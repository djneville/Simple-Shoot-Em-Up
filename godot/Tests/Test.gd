extends Node2D
class_name TestScene

const MOVE_SPEED = 10.0

var camera: Camera2D
var width = 540
var height = 960

var width1 = 256
var height1 = 384

func _ready() -> void:
    center_viewport()

func center_viewport() -> void:
    camera = Camera2D.new()
    camera.position = Vector2.ZERO
    camera.zoom = Vector2(1.0, 1.0)
    add_child(camera)

func _process(delta: float) -> void:
    var input_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
    for child in get_children():
        if child != camera:
            child.position += input_vector.normalized() * MOVE_SPEED * delta
            if child is PixelSnappingOnRotation:
                child.update_rotation(input_vector)
