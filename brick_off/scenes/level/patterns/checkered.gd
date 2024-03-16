extends Pattern
class_name Checkered

func build_pattern(grid: Vector2i, max_layer: int) -> void:
	var random_brick_a = randi_range(0, max_layer)
	var random_brick_b = randi_range(0, max_layer)
	
	while random_brick_b == random_brick_a:
		random_brick_b = randi_range(0, max_layer)
		
	for row in grid.y:
		for column in grid.x:
			var idx = row * grid.x + column
			var brick = random_brick_a if idx % 2 == 0 else random_brick_b
			brick_added.emit(grid, row, column, brick)
