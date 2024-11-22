extends Node

var projectile_scenes = {
    ProjectileType.TYPE.BULLET: preload("res://Scenes/Weapons/Projectiles/BulletComponent.tscn"),
    ProjectileType.TYPE.BOMB: preload("res://Scenes/Weapons/Projectiles/BombComponent.tscn"),
    ProjectileType.TYPE.MISSILE: preload("res://Scenes/Weapons/Projectiles/MissileComponent.tscn")
}

#TODO: should this just be part of some Resource??????
var projectile_attributes: Dictionary = {
    ProjectileType.TYPE.BULLET: {
        "damage": 1,
        "speed": 400.0,
        "lifetime": 10.0
    },
    ProjectileType.TYPE.BOMB: {
        "damage": 5,
        "speed": 200.0,
        "lifetime": 1.3
    },
    ProjectileType.TYPE.MISSILE: {
        "damage": 3,
        "speed": 300.0,
        "lifetime": 10.0
    }
}

func create_projectile(type: ProjectileType.TYPE, projectile_owner: Node, position: Vector2, direction: Vector2) -> Projectile:
    if projectile_scenes.has(type):
        var scene = projectile_scenes[type]
        var projectile: Projectile = scene.instantiate()
        var attrs = projectile_attributes[type]
        projectile.set_damage(attrs["damage"])
        projectile.set_speed(attrs["speed"])
        projectile.set_lifetime(attrs["lifetime"])
        projectile.set_direction(direction.normalized())
        projectile.set_projectile_owner(projectile_owner)
        projectile.position = position
        return projectile
    else:
        push_error("Unknown projectile type: %s" % type)
        return null
