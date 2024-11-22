extends Node
class_name WeaponFactory

#TODO: should this just be part of some Resource??????

const GUN_SCENE: String = "res://Scenes/Weapons/Gun.tscn"
const CANON_SCENE: String = "res://Scenes/Weapons/Canon.tscn"
const MISSILE_LAUNCHER_SCENE: String = "res://Scenes/Weapons/MissileLauncher.tscn"

var gun: Gun = preload(WeaponFactory.GUN_SCENE).instantiate() as Gun
var canon: Canon = preload(WeaponFactory.CANON_SCENE).instantiate() as Canon
var missile_launcher: MissileLauncher = preload(WeaponFactory.MISSILE_LAUNCHER_SCENE).instantiate() as MissileLauncher

var weapons: Dictionary = {
    WeaponType.TYPE.GUN: gun,
    WeaponType.TYPE.CANON: canon,
    WeaponType.TYPE.MISSILE_LAUNCHER: missile_launcher
}
