extends CanvasLayer

const LEVEL: String = "LEVEL: %d"
const SCORE: String = "SCORE: %d"
const GOAL: String = "GOAL: %d"
const TIME: String = "TIME: %02d:%02d"

@export var initial_time: float = 90

var _timer: Timer

func reset(level: int, score: int, goal: int, timer: Timer):
	%Level.text = LEVEL % level
	%Score.text = SCORE % level
	%Goal.text = GOAL % level
	_timer = timer
	_timer.start()
	show()

func _process(delta):
	if visible:
		%Time.text = _format_time()
	
func _format_time():
	var remaining_time = _timer.time_left
	var minutes = remaining_time / 60
	var seconds = fmod(remaining_time, 60)
	
	return TIME % [minutes, seconds]
