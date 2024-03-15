extends GPUParticles2D

const GREEN: Color = Color8(106, 190, 47)
const ORANGE: Color = Color8(251, 242, 54)
const RED: Color = Color8(217, 87, 99)
const BLUE: Color = Color8(215, 123, 186)
const PURPLE: Color = Color8(251, 242, 54)

const MAX_COLOR_VALUE: float = 255.0
const LEVEL_INTENSITY: float = MAX_COLOR_VALUE / Constants.MAX_LAYERS

const COLORS: Array[Color] = [GREEN, ORANGE, RED, BLUE, PURPLE]

func emit_for(brick: Brick) -> void:
	_align_with(brick)
	
	@warning_ignore("integer_division")
	var brick_level = brick.layer / Constants.MAX_LAYERS
	var brick_color = brick.layer % Constants.MAX_COLORS
	
	var color = COLORS[brick_color]
	
	color.a = _calculate_intensity(brick_level)

	process_material.color = color
	emitting = true
	
	await finished
	
	queue_free()

func _align_with(brick: Brick) -> void:
	position = brick.position
	scale = brick.scale

func _calculate_intensity(brick_level: int):
	return LEVEL_INTENSITY * (brick_level + 1) / MAX_COLOR_VALUE
