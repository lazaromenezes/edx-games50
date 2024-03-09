extends StaticBody2D
class_name Paddle

@export var move_speed: float = 300
@export var available_paddles: Array[AtlasTexture]

var _min_position: float
var _max_position: float

var initial_position: Vector2

var size: Vector2

func _ready() -> void:
	size = $Sprite2D.texture.region.size
	
	_set_boundaries()

	$Sprite2D.texture = available_paddles[GameState.selected_color]

func _physics_process(delta: float) -> void:
	var input = Input.get_axis("move_left", "move_right")
	
	var new_position = position.x + input * move_speed * delta
	
	position.x = clamp(new_position, _min_position, _max_position)

func reset() -> void:
	position = initial_position

func _set_boundaries():
	var screen_size = get_viewport_rect().size
	
	_min_position = size.x / 2 * scale.x
	_max_position = screen_size.x - _min_position