extends Node2D

func _ready():
    print("ready")

#TODO: maybe try the Boundary Nodes thing for all sides of the viewport, that way process 
# doesnt need to be called every frame
func _process(delta: float) -> void:
    _clamp_viewport()

func _clamp_viewport() -> void:
    var player_entity: CharacterBody2D = $CharacterBody2D
    var plane_sprite: Sprite2D = player_entity.upgrade_component.active_plane_sprite
    var texture_width: float = plane_sprite.texture.get_width()
    var texture_height: float = plane_sprite.texture.get_height()
    var viewport_size: Vector2 = get_viewport_rect().size
    
    player_entity.global_position.x = clamp(
        player_entity.global_position.x,
        texture_width / 2,
        viewport_size.x - texture_width / 2
    )
    
    player_entity.global_position.y = clamp(
        player_entity.global_position.y,
        texture_height / 2,
        viewport_size.y - texture_height / 2
    )
