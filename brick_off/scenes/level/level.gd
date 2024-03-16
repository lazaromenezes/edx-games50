extends Node2D

signal scored(points: int)
signal cleared()

const MAX_ROWS: int = 5
const MAX_COLS: int = 13
const MIN_COLS: int = 7

const MARGIN_TOP: int = 96
const BRICK_HEIGHT: int = 48

const MAX_COLORS: int = 5
const MAX_LAYERS: int = 4

var _brickScene = preload("res://scenes/brick/brick.tscn")
var _brickParticleScene = preload("res://scenes/particles/brick_particles.tscn")
var _viewport_size: Vector2

var patterns: Array[Pattern] = [
	StraightRow.new(),
	ColumnSkipper.new(),
	AlternateColors.new(),
	FullRandom.new(),
	Checkered.new(),
	CheckeredSkipper.new(),
]

func _ready() -> void:
	_viewport_size = get_viewport_rect().size
	
	for pattern in patterns:
		pattern.brick_added.connect(_on_brick_added)

func spawn_bricks(level: int = 1):
	@warning_ignore("integer_division")
	var max_layer = min(MAX_LAYERS - 1, level / MAX_LAYERS)
	@warning_ignore("integer_division")
	var max_color = min(MAX_COLORS - 1, level / MAX_COLORS + 2)
	
	var max_brick_layer = max_layer * MAX_COLORS + max_color
	var grid_size = _create_random_grid()
	
	var pattern = patterns.pick_random()
	
	pattern.build_pattern(grid_size, max_brick_layer)

	position.x = _viewport_size.x / 2.0
	position.y = MARGIN_TOP + (MAX_ROWS * BRICK_HEIGHT / 2.0)

func _create_random_grid() -> Vector2i:
	var rows = randi_range(1, MAX_ROWS)
	var cols = randi_range(MIN_COLS, MAX_COLS)
	cols += 1 if cols % 2 == 0 else 0
	
	return Vector2i(cols, rows)

func _on_brick_added(grid_size: Vector2i, row: int, column: int, brick_layer: int):
	var brick = _brickScene.instantiate()
	brick.hit.connect(_on_brick_hit)
	brick.tree_exited.connect(_check_clearence)
	brick.layer = brick_layer

	$Bricks.add_child(brick)
	brick.place(grid_size, row, column)

func _on_brick_hit(brick: Brick):
	scored.emit(brick.points)
	_emit_particles(brick)

func _emit_particles(brick: Brick):
	var particles = _brickParticleScene.instantiate()
	$Particles.add_child(particles)
	particles.emit_for(brick)

func _check_clearence() -> void:
	if $Bricks.get_child_count() == 0:
		cleared.emit()
