extends Node2D

const LEVEL_DISPLAY: String = "Level %d"
const PADDLE_BOTTOM_OFFSET: int = 15

enum State{SERVE, PLAY}

var _ball_scene: PackedScene = preload("res://scenes/ball/ball.tscn")

var _screen_size: Vector2
var _current_state: State = State.SERVE
var _current_level: int = 0

var _ball_count: int:
	get():
		return $Balls.get_child_count()

var _lifes: int = 3:
	set(value):
		_lifes = value
		%LifeBar.value = _lifes

@onready var paddle = $Paddle

func _ready() -> void:
	_screen_size = get_viewport_rect().size

	_set_paddle_initial_position()
	
	GameState.score_updated.connect(_update_score)

	_next_level()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		SceneManager.change_to(SceneManager.TITLE)

func _input(event: InputEvent) -> void:
	if _current_state == State.SERVE and event.is_action_pressed("serve"):
		%LevelDisplay.hide()
		_current_state = State.PLAY
		$Balls.get_children()[0].serve()
		
	if _current_state == State.PLAY and OS.has_feature("editor"):
		if event.is_action_pressed("ui_page_up"):
			$Paddle.increase()
		elif event.is_action_pressed("ui_page_down"):
			$Paddle.decrease()

func _new_ball(served: bool =  false):
	var ball = _ball_scene.instantiate()
	ball.initial_position = _calculate_ball_initial_position(ball)
	ball.reset()
	$Balls.call_deferred("add_child", ball)
	if served:
		ball.call_deferred("serve")

func _next_level():
	_current_level += 1
	_to_serve()
	await get_tree().create_timer(0.2).timeout
	$Level.call_deferred("spawn_bricks", _current_level)

func _set_paddle_initial_position():
	var initial_x = _screen_size.x / 2
	var initial_y = _screen_size.y - PADDLE_BOTTOM_OFFSET - $Paddle.size.y / 2

	$Paddle.initial_position = Vector2(initial_x, initial_y)

func _calculate_ball_initial_position(ball):
	var initial_x = $Paddle.position.x# - $Paddle.size.x / 2 - ball.size.x / 2
	var initial_y = $Paddle.position.y - $Paddle.size.y / 2 - ball.size.y / 2

	return Vector2(initial_x, initial_y)

func _on_bottom_body_exited(_body: Node2D) -> void:
	_body.queue_free()
	if _ball_count == 1:
		_lifes -= 1
		SfxPlayer.ball_lost.play()
		if _lifes > 0:
			_to_serve()
		else:
			SceneManager.change_to(SceneManager.GAME_OVER)

func _to_serve():
	_clear_all_balls()
	_clear_all_powerups()
	$Paddle.reset()
	_new_ball()
	_current_state = State.SERVE

	%LevelDisplay/Level.text = LEVEL_DISPLAY % _current_level
	%LevelDisplay.show()

func _clear_all_balls():
	for ball in $Balls.get_children():
		ball.queue_free()
		
func _clear_all_powerups():
	$Level.clear_all_powerups()

func _update_score(score: int):
	%Score.text = str(score)

func _on_level_scored(points: int) -> void:
	GameState.score += points
	paddle.increase_speed()

func _on_level_cleared() -> void:
	_next_level()

func _on_paddle_powerup_picked(kind: PowerupKind) -> void:
	SfxPlayer.powerup.play()
	kind.apply_effect(self)

func recover_life():
	if _lifes < 3:
		_lifes += 1

func spawn_extra_balls(amount: int):
	while amount > 0:
		_new_ball(true)
		amount -= 1
