extends Node2D

enum State {LEVEL_DISPLAY, PLAY, PREPARE}

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

func _ready() -> void:
	_next_level()

func _next_level():
	_state = State.LEVEL_DISPLAY
	_level += 1
	_goal = floori(_goal * goal_influence + _level * level_inflence * goal_constant_increase)
	$Timer.wait_time = initial_time + _level * level_inflence * time_constant_increase
	
	$GameHud.hide()
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
		$Timer.start()
	elif _state == State.PREPARE:
		_next_level()

func _on_game_board_scored(points):
	if _state == State.PLAY:
		_score += points
		$GameHud.update_score(_score)
		
		if _score >= _goal:
			_state = State.PREPARE
