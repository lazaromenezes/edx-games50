extends CanvasLayer

const LEVEL: String = "LEVEL: %d"
const SCORE: String = "SCORE: %d"
const GOAL: String = "GOAL: %d"
const TIME: String = "TIME: %02d:%02d"

var _timer: Timer

func reset(level: int, score: int, goal: int, timer: Timer):
	%Level.text = LEVEL % level
	%Goal.text = GOAL % goal
	update_score(score)
	_timer = timer
	_timer.start()
	show()

func _process(_delta):
	if visible:
		%Time.text = _format_time()
	
func _format_time():
	var remaining_time = _timer.time_left
	var minutes = remaining_time / 60
	var seconds = fmod(remaining_time, 60)
	
	return TIME % [minutes, seconds]

func update_score(new_score):
	%Score.text = SCORE % new_score
