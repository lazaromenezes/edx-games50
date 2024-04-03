extends Node2D

enum State {LEVEL_DISPLAY, PLAY}

@export var initial_time: float = 90

var _level: int = 0
var _state: State

var level_banner_scene = preload("res://scenes/level_banner/level_banner.tscn")

func _ready() -> void:
	$Timer.wait_time = initial_time
	_next_level()

func _next_level():
	_state = State.LEVEL_DISPLAY
	_level += 1
	
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
	$Board/GameBoard.new_board(_level)
	$GameHud.reset(_level, 0, 9000, $Timer)
	_state = State.PLAY
