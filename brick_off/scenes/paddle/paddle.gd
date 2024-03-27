extends StaticBody2D
class_name Paddle

signal paddle_changed(new_size: int)
signal powerup_picked(kind)

@export var initial_speed: float = 300
@export var max_speed: float = 500
@export var available_paddles: Array[PaddleSet]
@export var speed_increase_factor: float = 1.01

var _min_position: float
var _max_position: float

var initial_position: Vector2

var move_speed: float = initial_speed:
	set(value):
		move_speed = clamp(value, initial_speed, max_speed)

enum PaddleSize {SMALL, MEDIUM, LARGE, EXTRA}

var _current_set: PaddleSet
var _current_size: PaddleSize:
	set(value):
		_current_size = value
		paddle_changed.emit(value)

var size: Vector2:
	get():
		return $Sprite2D.texture.region.size * scale

func _ready() -> void:
	paddle_changed.connect(_on_paddle_changed)
	_current_set = available_paddles[GameState.selected_color]
	_current_size = PaddleSize.MEDIUM

func _physics_process(delta: float) -> void:
	var input = Input.get_axis("move_left", "move_right")
	
	constant_linear_velocity.x = input * move_speed * delta
	var new_position = position.x + constant_linear_velocity.x
	
	position.x = clamp(new_position, _min_position, _max_position)

func reset() -> void:
	_current_size = PaddleSize.MEDIUM
	move_speed = initial_speed
	position = initial_position

func _set_boundaries():
	var screen_size = get_viewport_rect().size
	
	_min_position = size.x / 2
	_max_position = screen_size.x - _min_position

func increase_speed():
	move_speed *= speed_increase_factor

func increase():
	if _current_size < PaddleSize.EXTRA:
		var new_size = _current_size + 1
		_current_size = new_size as PaddleSize

func decrease():
	if _current_size > PaddleSize.SMALL:
		var new_size = _current_size - 1
		_current_size = new_size as PaddleSize

func _on_paddle_changed(new_size):
	$Sprite2D.texture = _current_set.paddle_size[new_size]
	$CollisionShape2D.shape.size = $Sprite2D.texture.region.size
	_set_boundaries()
