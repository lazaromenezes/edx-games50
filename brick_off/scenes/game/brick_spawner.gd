extends Node2D

signal scored(points: int)

const MAX_ROWS: int = 5
const MAX_COLS: int = 13
const MIN_COLS: int = 7

const MARGIN_TOP: int = 96
const BRICK_HEIGHT: int = 48

var _brickScene = preload("res://scenes/brick/brick.tscn")
var _viewport_size: Vector2

func _ready() -> void:
	_viewport_size = get_viewport_rect().size

func spawn_bricks():
	var grid_size = _create_random_grid()

	for row in grid_size.y:
		for column in grid_size.x:
			_add_brick(grid_size, row, column)

	position.x = _viewport_size.x / 2.0
	position.y = MARGIN_TOP + (MAX_ROWS * BRICK_HEIGHT / 2.0)

func _create_random_grid() -> Vector2:
	var rows = randi_range(1, MAX_ROWS)
	var cols = randi_range(MIN_COLS, MAX_COLS)
	cols += 1 if rows % 2 == 0 else 0
	
	return Vector2(cols, rows)

func _add_brick(grid_size: Vector2, row: int, column: int):
	var brick = _brickScene.instantiate()
	brick.hit.connect(_on_brick_hit)
	add_child(brick)
	brick.place(grid_size, row, column)

func _on_brick_hit(points: int):
	scored.emit(points)
