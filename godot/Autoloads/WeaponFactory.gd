extends Node
class_name WeaponFactory

#TODO: should this just be part of some Resource??????

#TODO: YOU SHOULD SET THE PROJECTILE TYPES HERE,

const GUN_SCENE: String = "res://godot/Components/Weapons/Gun.tscn"
const CANON_SCENE: String = "res://godot/Components/Weapons/Canon.tscn"
const MISSILE_LAUNCHER_SCENE: String = "res://godot/Components/Weapons/MissileLauncher.tscn"

const TURRET_SCENE: String = "res://godot/Components/Weapons/Turret.tscn"
const ROCKET_LAUNCHER_SCENE: String = "res://godot/Components/Weapons/RocketLauncher.tscn"

var gun: Gun = preload(WeaponFactory.GUN_SCENE).instantiate() as Gun
var canon: Canon = preload(WeaponFactory.CANON_SCENE).instantiate() as Canon
var missile_launcher: MissileLauncher = (
    preload(WeaponFactory.MISSILE_LAUNCHER_SCENE).instantiate() as MissileLauncher
)

var turret: Turret = preload(WeaponFactory.TURRET_SCENE).instantiate() as Turret
var rocket_launcher: RocketLauncher = (
    preload(WeaponFactory.ROCKET_LAUNCHER_SCENE).instantiate() as RocketLauncher
)

var weapons: Dictionary = {
    WeaponType.TYPE.GUN: gun,
    WeaponType.TYPE.CANON: canon,
    WeaponType.TYPE.MISSILE_LAUNCHER: missile_launcher,
    WeaponType.TYPE.TURRET: turret,
    WeaponType.TYPE.ROCKET_LAUNCHER: rocket_launcher
}
