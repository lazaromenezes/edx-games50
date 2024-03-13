extends StaticBody2D
class_name Brick

signal hit(brick: Brick)

const MAX_COLORS: int = 5
const MAX_LAYERS: int = 4

const COLOR_POINTS: int = 10
const LAYER_POINTS: int = 100

var size: Vector2
var points: int:
	get():
		var layer_points = layer / MAX_LAYERS * LAYER_POINTS
		var color_points = (layer + 1) % MAX_COLORS * COLOR_POINTS
		
		return layer_points + color_points

@export
var brick_sets: Array[BrickSet]

var layer: int = 0

func _ready() -> void:
	size = $Sprite2D.texture.region.size * scale
	_render_brick_texture()

func place(grid_size: Vector2, row: int, column: int):
	grid_size *= 0.5

	position.x = (-grid_size.x + column) * size.x + size.x / 2
	position.y = (-grid_size.y + row) * size.y + size.y / 2

func _on_area_2d_body_entered(_body: Node2D) -> void:
	hit.emit(self)
	
	if layer == 0:
		queue_free()
	else:
		layer -= 1
		_render_brick_texture()
	
func _render_brick_texture() -> void:
	var brick_set = layer / MAX_LAYERS
	var set_layer = layer % MAX_COLORS
	
	$Sprite2D.texture = brick_sets[brick_set].layers[set_layer]
