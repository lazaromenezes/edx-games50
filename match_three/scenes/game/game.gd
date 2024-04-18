extends Node2D

enum State {LEVEL_DISPLAY, PLAY, PREPARE, GAME_OVER}

@export var initial_time: float = 60
@export var level_inflence: float = 1.25
@export var goal_influence: float = 0.25
@export var goal_constant_increase: int = 100
@export var time_constant_increase: int = 5

var _level: int = 0
var _state: State
var _score: int = 0
var _goal: int = 0

var level_banner_scene = preload("res://scenes/level_banner/level_banner.tscn")

var _ticked: bool = true

func _ready() -> void:
	_next_level()

func _process(delta):
	if $Timer.time_left <= 5 and $Timer.time_left > 0:
		if _ticked:
			get_tree().create_timer(1).timeout.connect(_on_tick)
		_ticked = false

func _on_tick():
	GameEvents.clock_tick.emit()
	_ticked = true

func _next_level():
	_state = State.LEVEL_DISPLAY
	_level += 1
	_goal = floori(_goal * goal_influence + _level * level_inflence * goal_constant_increase)
	$Timer.wait_time = initial_time + _level * level_inflence * time_constant_increase
	$GameHud.hide()
	GameEvents.new_level.emit()
	_show_banner()

func _show_banner():
	var level_banner = level_banner_scene.instantiate()
	level_banner.set_level(_level)
	level_banner.displayed.connect(_on_banner_displayed)
	add_child(level_banner)

func _on_banner_displayed():
	_prepare()

func _prepare():
	$GameHud.reset(_level, _score, _goal, $Timer)
	$Board/GameBoard.new_board(_level)

func _on_game_board_board_ready():
	if _state == State.LEVEL_DISPLAY:
		_state = State.PLAY
		$Timer.paused = false
		$Timer.start()
	elif _state == State.PREPARE:
		_next_level()

func _on_game_board_scored(points):
	if _state == State.PLAY:
		_score += points
		$GameHud.update_score(_score)
		
		if _score >= _goal:
			$Timer.paused = true
			_state = State.PREPARE

func _on_timer_timeout():
	_show_game_over()

func _show_game_over():
	GameEvents.game_over.emit()
	$Board.process_mode = Node.PROCESS_MODE_DISABLED
	$GameHud.process_mode = Node.PROCESS_MODE_DISABLED
	
	_state = State.GAME_OVER
	
	var panel = $GameOver/Panel
	panel.modulate.a = 0
	
	$GameOver.show()
	
	var tween = create_tween()
	tween.tween_property(panel, "modulate:a", 1, 0.5)
	
func _on_button_pressed():
	if _state == State.GAME_OVER:
		SceneManager.change_to(SceneManager.TITLE)

func _on_game_board_matches_exhausted():
	$Timer.stop()
	_show_game_over()
	
