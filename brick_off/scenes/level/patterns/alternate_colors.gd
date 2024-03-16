extends Pattern
class_name AlternateColors

func build_pattern(grid: Vector2i, max_layer: int) -> void:
	var random_brick_a = randi_range(0, max_layer)
	var random_brick_b = randi_range(0, max_layer)
	
	for row in grid.y:
		for column in grid.x:
			var brick = random_brick_a if column %2 == 0 else random_brick_b
			brick_added.emit(grid, row, column, brick)
