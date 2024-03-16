extends Pattern
class_name StraightRow

func build_pattern(grid: Vector2i, max_layer: int) -> void:
	for row in grid.y:
		var random_brick = randi_range(0, max_layer)
		for column in grid.x:
			brick_added.emit(grid, row, column, random_brick)
