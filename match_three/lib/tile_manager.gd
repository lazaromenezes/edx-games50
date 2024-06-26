extends RefCounted
class_name TileManager

const TILE_SIZE: int = 32
const COLOR_COUNT: int = 18
const TILE_SHAPES: int = 6
const COLUMNS: int = 12
const ROWS: int = 9

static var tile_set: Texture2D = preload("res://assets/match3.png")
static var tiles: Array[Tile] = []

static func _static_init() -> void:
	tiles = _load_tiles()

static func _load_tiles():
	var loaded_tiles: Array[Tile] = []
	
	for r in ROWS:
		for c in COLUMNS:
			@warning_ignore("integer_division")
			var color_id = r * 2 + c / TILE_SHAPES
			var shape_id = c % TILE_SHAPES
			var texture: AtlasTexture = _build_texture(r, c)
			
			loaded_tiles.push_back(Tile.new(color_id, shape_id, texture))
	
	return loaded_tiles
	
static func _build_texture(row: int, column: int):
	var region = Rect2(column * TILE_SIZE, row * TILE_SIZE, TILE_SIZE, TILE_SIZE)
	
	var texture: AtlasTexture = AtlasTexture.new()
	texture.atlas = tile_set
	texture.region = region
	
	return texture
	
static func random_tile(level: int = 1):
	@warning_ignore("integer_division")
	var max_shape = level / TILE_SHAPES
	var max_color = level + 2
	
	var filtered_tiles = tiles.filter(_filter_tile.bind(max_color, max_shape))
	
	var tile: Tile = Tile.from(filtered_tiles.pick_random())
	tile.shiny = randi() % 100 == 0
	return tile

static func _filter_tile(tile: Tile, max_color: int, max_shape: int):
	return tile.shape_id <= max_shape and tile.color_id < max_color
