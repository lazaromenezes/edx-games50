extends Node2D

const LEVEL_DISPLAY: String = "Level %d"
const PADDLE_BOTTOM_OFFSET: int = 15

enum State{SERVE, PLAYING}

var _current_state: State = State.SERVE
var _current_level: int = 0

func _ready() -> void:
	var screen_size = get_viewport_rect().size

	_set_paddle_initial_position(screen_size)
	_set_ball_initial_position(screen_size)

	_next_level()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		SceneManager.change_to(SceneManager.TITLE)

func _input(event: InputEvent) -> void:
	if _current_state == State.SERVE and event.is_action_pressed("serve"):		
		%LevelDisplay.hide()
		_current_state = State.PLAYING
		$Ball.serve()

func _next_level():
	$Ball.reset()
	$Paddle.reset()

	_current_level += 1
	_current_state = State.SERVE

	%LevelDisplay/Level.text = LEVEL_DISPLAY % _current_level
	%LevelDisplay.show()

func _set_paddle_initial_position(screen_size: Vector2):
	var initial_x = screen_size.x / 2
	var initial_y = screen_size.y - PADDLE_BOTTOM_OFFSET - $Paddle.size.y / 2

	$Paddle.initial_position = Vector2(initial_x, initial_y)

func _set_ball_initial_position(screen_size: Vector2):
	var initial_x = screen_size.x / 2
	var initial_y = $Paddle.position.y - $Paddle.size.y / 2 - $Ball.size.y / 2

	$Ball.initial_position = Vector2(initial_x, initial_y)