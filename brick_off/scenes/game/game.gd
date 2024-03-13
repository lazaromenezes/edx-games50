extends Node2D

const LEVEL_DISPLAY: String = "Level %d"
const PADDLE_BOTTOM_OFFSET: int = 15

enum State{SERVE, PLAY}

var _current_state: State = State.SERVE
var _current_level: int = 0
var _lifes: int = 3

func _ready() -> void:
	var screen_size = get_viewport_rect().size

	_set_paddle_initial_position(screen_size)
	_set_ball_initial_position(screen_size)

	_update_life_bar()
	_update_score()

	_next_level()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		SceneManager.change_to(SceneManager.TITLE)

func _input(event: InputEvent) -> void:
	if _current_state == State.SERVE and event.is_action_pressed("serve"):		
		%LevelDisplay.hide()
		_current_state = State.PLAY
		$Ball.serve()

func _next_level():
	_current_level += 1
	_to_serve()
	await get_tree().create_timer(0.2).timeout
	$Level.call_deferred("spawn_bricks")

func _set_paddle_initial_position(screen_size: Vector2):
	var initial_x = screen_size.x / 2
	var initial_y = screen_size.y - PADDLE_BOTTOM_OFFSET - $Paddle.size.y / 2

	$Paddle.initial_position = Vector2(initial_x, initial_y)

func _set_ball_initial_position(screen_size: Vector2):
	var initial_x = screen_size.x / 2
	var initial_y = $Paddle.position.y - $Paddle.size.y / 2 - $Ball.size.y / 2

	$Ball.initial_position = Vector2(initial_x, initial_y)

func _on_bottom_body_exited(_body: Node2D) -> void:
	_lifes -= 1
	_update_life_bar()
	_to_serve() if _lifes > 0 else SceneManager.change_to(SceneManager.GAME_OVER)

func _to_serve():
	$Ball.reset()
	$Paddle.reset()
	
	_current_state = State.SERVE

	%LevelDisplay/Level.text = LEVEL_DISPLAY % _current_level
	%LevelDisplay.show()

func _update_life_bar():
	%LifeBar.value = _lifes

func _update_score():
	%Score.text = str(GameState.score)

func _on_level_scored(points: int) -> void:
	GameState.score += points
	_update_score()

func _on_level_cleared() -> void:
	_next_level()
