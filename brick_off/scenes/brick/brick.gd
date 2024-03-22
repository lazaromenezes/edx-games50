extends StaticBody2D
class_name Brick

signal hit(brick: Brick)
signal destroyed(brick: Brick)

const COLOR_POINTS: int = 10
const LAYER_POINTS: int = 100

var size: Vector2
var points: int:
	get():
		@warning_ignore("integer_division")
		var layer_points = layer / Constants.MAX_LAYERS * LAYER_POINTS
		var color_points = (layer + 1) % Constants.MAX_COLORS * COLOR_POINTS
		
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
		SfxPlayer.brick_destroy.play()
		destroyed.emit(self)
		queue_free()
	else:
		SfxPlayer.brick_hit.play()
		layer -= 1
		_render_brick_texture()

func _render_brick_texture() -> void:
	@warning_ignore("integer_division")
	var brick_set = layer / Constants.MAX_COLORS
	var brick_color = layer % Constants.MAX_COLORS
	
	$Sprite2D.texture = brick_sets[brick_set].layers[brick_color]
