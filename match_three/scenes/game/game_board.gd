extends Node2D

@export var board_size: Vector2 = Vector2(8, 8)
@export var swap_time: float = 0.1

var _tile_scene: PackedScene = preload("res://scenes/play_tile/play_tile.tscn")
var _viewport_halfed: Vector2

var _current_selected: PlayTile = null
var _tiles: Array[Array] = []

var _valid_move: bool = true

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
		_tiles.push_back([])
		for column in board_size.y:
			var tile = TileManager.random_tile()
			_add_tile(tile, row, column)

func _add_tile(tile, row, column) -> void:
	var play_tile = _tile_scene.instantiate()
	play_tile.tile = tile
	play_tile.position = Vector2(column * TileManager.TILE_SIZE, row * TileManager.TILE_SIZE)
	play_tile.selected.connect(_on_tile_selected)
	add_child(play_tile)
	_tiles[row].push_back(play_tile)

func _centralize():
	var half_board_size = (board_size * TileManager.TILE_SIZE) / 2.0
	var offset = Vector2(TileManager.TILE_SIZE, TileManager.TILE_SIZE) / 2.0
	
	position = _viewport_halfed - half_board_size + offset
	
	_move_right()

func _move_right():
	var tween = create_tween()
	tween.tween_property(self, "position:x", _viewport_halfed.x , 0.1)
	
func _on_tile_selected(selected_tile):
	if _current_selected == null:
		_current_selected = selected_tile
	else:
		if _are_adjacent(_current_selected, selected_tile):
			await _swap(_current_selected, selected_tile)
			if !_has_matches():
				await _swap(_current_selected, selected_tile)
				
			_current_selected._selected = false
			selected_tile._selected = false
			_current_selected = null
		else:
			selected_tile._selected = false

func _swap(a: PlayTile, b: PlayTile):
	await _swap_positions(a, b)
	_swap_indexes(a, b)

func _swap_indexes(a: PlayTile, b: PlayTile) -> void:
	var index_a = _find_indexes(a)
	var index_b = _find_indexes(b)
	
	var temp = _tiles[index_a.y][index_a.x]
	_tiles[index_a.y][index_a.x] = _tiles[index_b.y][index_b.x]
	_tiles[index_b.y][index_b.x] = temp

func _find_indexes(t: PlayTile) -> Vector2:
	return Vector2(t.position / TileManager.TILE_SIZE)

func _swap_positions(a: PlayTile, b: PlayTile):
	var a_position = a.position
	var b_position = b.position
	
	var tween = create_tween()
	tween.tween_property(a, "position", b_position, swap_time)
	tween.parallel().tween_property(b, "position", a_position, swap_time)
	await tween.finished

func _are_adjacent(a: PlayTile, b: PlayTile):
	var a_index = _find_indexes(a)
	var b_index = _find_indexes(b)
	
	var x_diff = abs(a_index.x - b_index.x)
	var y_diff = abs(a_index.y - b_index.y)
	
	return x_diff + y_diff == 1
	
func _has_matches():
	_valid_move = !_valid_move
	return _valid_move

func _debug(t, a, b):
	print_debug("[%s] A: %s B: %s" % [t, a.position, b.position])
