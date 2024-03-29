extends Node2D

@export var board_size: Vector2 = Vector2(8, 8)

func _ready() -> void:
	for row in board_size.x:
		for column in board_size.y:
			var tile = TileManager.random_tile()
			_add_sprite(tile, row, column)
			
	var total_size = board_size * TileManager.TILE_SIZE
	
	@warning_ignore("integer_division")
	position.x = get_viewport_rect().size.x / 2.0 - total_size.x / 2 + TileManager.TILE_SIZE / 2
	@warning_ignore("integer_division")
	position.y = get_viewport_rect().size.y / 2.0 - total_size.y / 2 + TileManager.TILE_SIZE / 2

func _add_sprite(tile, row, column) -> void:
	var sprite = Sprite2D.new()
	sprite.texture = tile.texture
	sprite.position = Vector2(row * TileManager.TILE_SIZE, column * TileManager.TILE_SIZE)
	add_child(sprite)
