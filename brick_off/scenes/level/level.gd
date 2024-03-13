extends Node2D

signal scored(points: int)
signal cleared()

const MAX_ROWS: int = 5
const MAX_COLS: int = 13
const MIN_COLS: int = 7

const MARGIN_TOP: int = 96
const BRICK_HEIGHT: int = 48

@export
var available_brick_sets: Array[BrickSet]

var _brickScene = preload("res://scenes/brick/brick.tscn")
var _viewport_size: Vector2

func _ready() -> void:
	_viewport_size = get_viewport_rect().size

func spawn_bricks():
	var grid_size = _create_random_grid()
	
	for row in grid_size.y:
		
		var brick_set = available_brick_sets.pick_random()
		
		for column in grid_size.x:
			_add_brick(grid_size, row, column, brick_set)
			

	position.x = _viewport_size.x / 2.0
	position.y = MARGIN_TOP + (MAX_ROWS * BRICK_HEIGHT / 2.0)

func _create_random_grid() -> Vector2:
	var rows = randi_range(1, MAX_ROWS)
	var cols = randi_range(MIN_COLS, MAX_COLS)
	cols += 1 if rows % 2 == 0 else 0
	
	return Vector2(cols, rows)

func _add_brick(grid_size: Vector2, row: int, column: int, brick_set: BrickSet = null):
	var brick = _brickScene.instantiate()
	brick.hit.connect(_on_brick_hit)
	brick.tree_exited.connect(_check_clearence)
	
	if brick_set:
		brick.brick_set = brick_set
		
	add_child(brick)
	brick.place(grid_size, row, column)

func _on_brick_hit(brick: Brick):
	scored.emit(brick.points)
	brick.queue_free()

func _check_clearence() -> void:
	if get_child_count() == 0:
		cleared.emit()