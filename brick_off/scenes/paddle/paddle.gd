extends StaticBody2D

@export var move_speed: float = 100

var _min_position: float
var _max_position: float

func _ready() -> void:
	_min_position = $Sprite2D.texture.region.size.x / 2 * scale.x
	_max_position = get_viewport_rect().size.x - _min_position

	$Sprite2D.texture = GameState.selected_paddle_texture

func _physics_process(delta: float) -> void:
	var input = Input.get_axis("move_left", "move_right")
	
	var new_position = position.x + input * move_speed * delta
	
	position.x = clamp(new_position, _min_position, _max_position)
