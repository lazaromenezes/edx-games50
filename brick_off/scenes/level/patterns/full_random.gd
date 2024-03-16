extends Pattern
class_name FullRandom

func build_pattern(grid: Vector2i, max_layer: int) -> void:
	for row in grid.y:
		for column in grid.x:
			brick_added.emit(grid, row, column, randi_range(0, max_layer))
