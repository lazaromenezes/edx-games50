extends Node2D

signal board_ready()

@export var board_size: Vector2 = Vector2(8, 8)
@export var swap_time: float = 0.1
@export var validate_adjacents: bool = true

var _tile_scene: PackedScene = preload("res://scenes/play_tile/play_tile.tscn")
var _viewport_halfed: Vector2

var _current_selected: PlayTile = null
var _tiles: Array[Array] = []
var _valid_move: bool = true
var _can_score: bool = false

func _ready():
	_viewport_halfed = get_viewport_rect().size / 2.0

func new_board(level: int):
	_clear()
	_add_tiles()
	_centralize()
	await _move_right()
	_check_for_matches(_ready_to_play)

func _ready_to_play():
	_can_score = true
	board_ready.emit()

func _clear():
	for tile in get_children():
		tile.queue_free()

func _add_tiles():
	for row in board_size.x:
		_tiles.push_back([])
		for column in board_size.y:
			_add_tile(row, column)

func _add_tile(row, column) -> void:
	var play_tile = _new_tile(row, column)
	add_child(play_tile)
	_tiles[row].push_back(play_tile)

func _new_tile(row, column):
	var play_tile = _tile_scene.instantiate()
	play_tile.tile = TileManager.random_tile()
	play_tile.position = Vector2(column * TileManager.TILE_SIZE, row * TileManager.TILE_SIZE)
	play_tile.selected.connect(_on_tile_selected)
	return play_tile

func _centralize():
	var half_board_size = (board_size * TileManager.TILE_SIZE) / 2.0
	var offset = Vector2(TileManager.TILE_SIZE, TileManager.TILE_SIZE) / 2.0
	
	position = _viewport_halfed - half_board_size + offset

func _move_right():
	var tween = create_tween()
	tween.tween_property(self, "position:x", _viewport_halfed.x , 0.1)
	await tween.finished

func _on_tile_selected(selected_tile):
	if _current_selected == null:
		_current_selected = selected_tile
	elif _current_selected == selected_tile:
		_current_selected = null
		selected_tile._selected = false
	else:
		if _are_adjacent(_current_selected, selected_tile):
			await _swap(_current_selected, selected_tile)
			_check_for_matches(_swap.bind(_current_selected, selected_tile))
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
	if not validate_adjacents:
		return true
		
	var a_index = _find_indexes(a)
	var b_index = _find_indexes(b)
	
	var x_diff = abs(a_index.x - b_index.x)
	var y_diff = abs(a_index.y - b_index.y)
	
	return x_diff + y_diff == 1

func _check_for_matches(when_not_found: Callable):
	var matches = _find_matches()
	if matches.is_empty():
		when_not_found.call()
	else:
		_clear_matches(matches)
		_adjust_board()

func _find_matches():
	var matches: Array[Match] = []
	
	_find_horizontal_matches(matches)
	_find_vertical_matches(matches)
	
	return matches

func _find_horizontal_matches(matches: Array[Match]):
	for row in board_size.x:
		
		var matching_pile = []
		var match_count = 1
		var reference_tile = null
		
		for column in board_size.y:
			var play_tile = _tiles[row][column]
			
			if not play_tile.tile.is_equal(reference_tile):
				if match_count >= 3:
					matches.push_back(Match.new(matching_pile))
					
				reference_tile = play_tile.tile
				match_count = 1
				matching_pile = [play_tile]
			else:
				matching_pile.push_back(play_tile)
				match_count += 1
				
		if match_count >= 3:
				matches.push_back(Match.new(matching_pile))

func _find_vertical_matches(matches: Array[Match]):
	for row in board_size.x:
		
		var matching_pile = []
		var match_count = 1
		var reference_tile = null
		
		for column in board_size.y:
			var play_tile = _tiles[column][row]
			
			if not play_tile.tile.is_equal(reference_tile):
				if match_count >= 3:
					matches.push_back(Match.new(matching_pile))
					
				reference_tile = play_tile.tile
				match_count = 1
				matching_pile = [play_tile]
			else:
				matching_pile.push_back(play_tile)
				match_count += 1
				
		if match_count >= 3:
				matches.push_back(Match.new(matching_pile))

func _clear_matches(matches: Array):
	for tile_match in matches:
		for tile in tile_match.tiles:
			var tile_index = _find_indexes(tile)
			_tiles[tile_index.y][tile_index.x] = null
			tile.queue_free()

func _adjust_board():
	
	var tween = get_tree().create_tween()
	
	for column in board_size.y:
		var empty_slot = -1
		var space = false
		var row = 7
		
		while row >= 0:
			var tile = _tiles[row][column]
			
			if space:
				if tile:
					_tiles[empty_slot][column] = tile
					
					tween\
					.parallel()\
					.tween_property(tile, "position:y", TileManager.TILE_SIZE * empty_slot, 0.15)
					
					_tiles[row][column] = null
					
					space = false
					row = empty_slot
					empty_slot = -1
			elif tile == null:
				space = true
				if empty_slot == -1:
					empty_slot = row
			
			row -= 1

	tween.tween_callback(_refill)

	await tween.finished

func _refill():
	var tween = get_tree().create_tween()
	
	for y in board_size.y:
		for x in range(board_size.x - 1, -1, -1):
			var tile = _tiles[x][y]
			
			if tile == null:
				var play_tile = _new_tile(x, y)
				_tiles[x][y] = play_tile
				
				var original_position = play_tile.position
				play_tile.position.y = -50
				add_child(play_tile)
				
				tween\
				.parallel()\
				.tween_property(play_tile, "position:y", original_position.y, 0.15)

	tween.tween_callback(_check_for_matches.bind(_ready_to_play))

	await tween.finished

func _replace_tile(row, column):
	var play_tile = _new_tile(row, column)
	_tiles[row][column] = play_tile
	
	var original_position = play_tile.position
	play_tile.position.y = -50
	add_child(play_tile)
	_move_tile(play_tile, original_position)

func _move_tile(tile: PlayTile, to: Vector2):
	var tween = get_tree().create_tween()
	tween.tween_property(tile, "position", to, 0.15)

class Match:
	const MIN_MATCH = 3
	
	var tiles: Array
	var points: int:
		get():
			var count = tiles.size()
			return count + 2 ** (count - MIN_MATCH) - 1
	
	func _init(matching_tiles):
		self.tiles = matching_tiles

	func _to_string():
		return "COUNT: %d POINTS: %d" % [tiles.size(), points]
