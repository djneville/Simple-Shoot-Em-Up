extends Resource
class_name UpgradeData

#Cant export Node types in Resources, only NodePaths

@export var order: int
@export var plane_sprite_texture: Texture2D
@export var collision_shape: RectangleShape2D
@export var speed: float
@export var projectile_type: Projectile.TYPE
@export var explosion_animation_sprites: SpriteFrames #TODO; figure out animations later
