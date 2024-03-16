extends Pattern
class_name CheckeredSkipper

func build_pattern(grid: Vector2i, max_layer: int) -> void:
	for row in grid.y:
		var random_brick = randi_range(0, max_layer)
		for column in grid.x:
			var render = (row * grid.x + column) % 2 == 0
			if render:
				brick_added.emit(grid, row, column, random_brick)
