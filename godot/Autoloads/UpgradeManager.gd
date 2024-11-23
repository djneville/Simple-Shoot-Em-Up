extends Node

var upgrades: Array[UpgradeData] = []


func _ready() -> void:
    load_upgrades()


func load_upgrades() -> void:
    var upgrade_dir: String = "res://Resources/UpgradeData/"
    var dir: DirAccess = DirAccess.open(upgrade_dir)
    dir.list_dir_begin()
    var file_name: String = dir.get_next()
    while file_name != "":
        var resource_path: String = upgrade_dir + file_name
        if file_name.ends_with(".tres"):
            #TODO: figure out better resource error checking??
            var upgrade_resource: UpgradeData = ResourceLoader.load(resource_path)
            upgrades.append(upgrade_resource)
        file_name = dir.get_next()
    dir.list_dir_end()
    upgrades.sort_custom(func(x: UpgradeData, y: UpgradeData) -> bool: return x.order < y.order)
