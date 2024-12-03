extends Node2D
class_name GlacierGen

var glacier_surface: TileMapLayer

var glacier_states_instance: GlacierCellState = GlacierCellState.new() #TODO: I REALLY DONT LIKE THIS, but godot.. and issue with true singletons

func _ready() -> void:
    initialize_glacier_surface()

func initialize_glacier_surface() -> void:
    glacier_surface = TileMapLayer.new()
    glacier_surface.rendering_quadrant_size = 16
    var glacier_tileset: TileSet = create_and_save_glacier_tile_set()
    glacier_surface.set_tile_set(glacier_tileset)
    # fill_with_intact_tiles() #THIS DOESNT WORK
    var glacier_scene: PackedScene = PackedScene.new()
    glacier_scene.pack(glacier_surface)
    ResourceSaver.save(glacier_scene, "res://godot/Scenes/Glaciers/GlacierMap1.tscn")

# New Method to Fill the TileMapLayer with INTACT Tiles
func fill_with_intact_tiles() -> void:
    for x: int in range(16):
        for y: int in range(8):
            self.glacier_surface.set_cell(Vector2i(x, y), -1, Vector2i(GlacierCellState.STATE.INTACT,0))
    glacier_surface.update_internals()



#TODO: this is not creating a usable tileset/atlas. I should only be making a single Atlas that has multiple of those images in it
# DO NOT MAKE A WHOLE AT LAS FOR EACH TILE. THATS BROKEN AND UNUSABLE
func create_and_save_glacier_tile_set() -> TileSet:
    var glacier_tileset: TileSet = TileSet.new()
    for tile_index: GlacierCellState.STATE in GlacierCellState.STATE.values():
        var atlas_source: TileSetAtlasSource = TileSetAtlasSource.new()
        atlas_source.set_texture_region_size(Vector2i(16, 16))
        var color: Color = glacier_states_instance.get_color(tile_index)

        var image: Image = Image.create_empty(16, 16, false, Image.FORMAT_RGBA8)
        for i: int in range(16):
            for j: int in range(16):
                image.set_pixel(i, j, color)

        var texture: ImageTexture = ImageTexture.create_from_image(image)

        atlas_source.set_texture(texture)

        var atlas_coords: Vector2i = Vector2i(tile_index, 0)
        atlas_source.create_tile(atlas_coords)  # ATLAS SOURCES ARE INDIVIDUAL SINGLE TILEDATA AHHHHHH!!!
        glacier_tileset.set_tile_size(Vector2i(16,16))
        glacier_tileset.add_source(atlas_source)

    ResourceSaver.save(glacier_tileset, "res://Resources/TileSets/glacier_tileset.tres")
    return glacier_tileset
