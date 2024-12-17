extends Node2D
class_name GlacierGen

const GRID_WIDTH = 16
const GRID_HEIGHT = 8
const SOURCE_ID = 234

var glacier_states_instance: GlacierCellState = GlacierCellState.new() #TODO: I REALLY DONT LIKE THIS

var glacier_surface: TileMapLayer

func _ready() -> void:
    initialize_glacier_surface()

func initialize_glacier_surface() -> void:
    glacier_surface = TileMapLayer.new()
    var glacier_tileset: TileSet = create_and_save_glacier_tile_set()
    glacier_surface.set_tile_set(glacier_tileset)
    glacier_tileset = glacier_surface.get_tile_set()
    fill_with_intact_tiles()
    var glacier_scene: PackedScene = PackedScene.new()
    glacier_scene.pack(glacier_surface)
    ResourceSaver.save(glacier_scene, "res://godot/Scenes/Glaciers/GlacierMap.tscn")

func fill_with_intact_tiles() -> void:
    for x: int in range(GRID_WIDTH):
        for y: int in range(GRID_HEIGHT):
            glacier_surface.set_cell(Vector2i(x, y), SOURCE_ID, Vector2i(0,GlacierCellState.STATE.INTACT))

# EXPLICIT CONSTS FOR TESTS/DEBUG
const IMAGE_TEXTURE_SIZE = Vector2i(16, 16)
const TEXTURE_REGION_SIZE = Vector2i(16, 16)
const MARGIN = (TEXTURE_REGION_SIZE - IMAGE_TEXTURE_SIZE) / 2
const ATLAS_MARGINS = Vector2i(0, 0) #  margins as a property? rather than from the in the texture_region and ImageTexture diff...
const TILE_SIZE = IMAGE_TEXTURE_SIZE
const GRID_TILE_SIZE = Vector2i(1, 1)
const ATLAS_SEPARATION = Vector2i(0, 0)

func create_and_save_glacier_tile_set() -> TileSet:
    var glacier_states = GlacierCellState.STATE.values()
    var glacier_tileset: TileSet = TileSet.new()
    glacier_tileset.set_tile_size(TILE_SIZE)
    var atlas_source: TileSetAtlasSource = TileSetAtlasSource.new()
    atlas_source.set_margins(ATLAS_MARGINS)
    atlas_source.set_separation(ATLAS_SEPARATION)
    atlas_source.set_use_texture_padding(true)

    var atlas_texture_width = TEXTURE_REGION_SIZE.x
    var atlas_texture_height = TEXTURE_REGION_SIZE.y * glacier_states.size()
    var atlas_texture: Image = Image.create_empty(atlas_texture_width, atlas_texture_height, false, Image.FORMAT_RGBA8)
    atlas_source.set_texture_region_size(TEXTURE_REGION_SIZE)
    for tile_index in range(glacier_states.size()):
        var state = glacier_states[tile_index]
        var color: Color = glacier_states_instance.get_color(state)
        var x_offset: int = MARGIN.x + ATLAS_MARGINS.x
        var y_offset: int = TEXTURE_REGION_SIZE.y * tile_index + MARGIN.y + ATLAS_MARGINS.y
        for i in range(IMAGE_TEXTURE_SIZE.x):
            for j in range(IMAGE_TEXTURE_SIZE.y):
                atlas_texture.set_pixel(x_offset + i, y_offset + j, color)

        #var atlas_coords: Vector2i = Vector2i(0, tile_index)
        #atlas_source.create_tile(atlas_coords, GRID_TILE_SIZE)

    var final_texture: ImageTexture = ImageTexture.create_from_image(atlas_texture)
    atlas_source.set_texture(final_texture)

    for tile_index in range(glacier_states.size()):
        var atlas_coords: Vector2i = Vector2i(0, tile_index)
        atlas_source.create_tile(atlas_coords, GRID_TILE_SIZE)

    #TODO: this is gross, and a bug I hope... but current workaround for setting the tiles to usable
    #atlas_source.set("0:1/0", 0)
    #atlas_source.set("0:2/0", 0)
    #atlas_source.set("0:3/0", 0)
    #atlas_source.set("0:0/0", 0)
    glacier_tileset.add_source(atlas_source)
    glacier_tileset.set_source_id(0, SOURCE_ID) #some random id to test the set_cell later on
    #TODO: something about when you save this tileset you have to go into the tile set and select them all to use them??
    ResourceSaver.save(glacier_tileset, "res://Resources/TileSets/glacier_tileset.tres")
    return glacier_tileset
