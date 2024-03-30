extends Node2D

@export var board_size: Vector2 = Vector2(8, 8)

var _viewport_halfed: Vector2

func _ready():
	_viewport_halfed = get_viewport_rect().size / 2.0

func new_board(level: int):
	_clear()
	_add_tiles()
	_centralize()

func _clear():
	for tile in get_children():
		tile.queue_free()

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

func _centralize():
	var half_board_size = (board_size * TileManager.TILE_SIZE) / 2.0
	var offset = Vector2(TileManager.TILE_SIZE, TileManager.TILE_SIZE) / 2.0
	
	position = _viewport_halfed - half_board_size + offset
	
	_move_right()

func _move_right():
	var tween = create_tween()
	tween.tween_property(self, "position:x", _viewport_halfed.x , 0.1)
