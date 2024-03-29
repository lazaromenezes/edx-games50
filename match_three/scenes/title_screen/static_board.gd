extends Node2D

@export var board_size: Vector2 = Vector2(8, 8)

func _ready() -> void:
	_add_tiles()
	_adjust_position()

func _add_tiles():
	for row in board_size.x:
		for column in board_size.y:
			var tile = TileManager.random_tile()
			_add_sprite(tile, row, column)

func _add_sprite(tile, row, column) -> void:
	var sprite = Sprite2D.new()
	sprite.texture = tile.texture
	sprite.position = Vector2(row * TileManager.TILE_SIZE, column * TileManager.TILE_SIZE)
	add_child(sprite)

func _adjust_position():
	var half_board_size = (board_size * TileManager.TILE_SIZE) / 2.0
	var view_port_halfed = get_viewport_rect().size / 2.0
	var offset = Vector2(TileManager.TILE_SIZE, TileManager.TILE_SIZE) / 2.0
	
	position = view_port_halfed - half_board_size + offset
