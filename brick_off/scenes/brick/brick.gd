extends StaticBody2D
class_name Brick

signal hit(brick: Brick)

var size: Vector2
var points: int = 10

func _ready() -> void:
	size = $Sprite2D.texture.region.size * scale

func place(grid_size: Vector2, row: int, column: int):
	grid_size *= 0.5

	position.x = (-grid_size.x + column) * size.x + size.x / 2
	position.y = (-grid_size.y + row) * size.y + size.y / 2

func _on_area_2d_body_entered(_body: Node2D) -> void:
	hit.emit(self)
