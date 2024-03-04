extends CanvasLayer

signal finished()

const COUNTDOWN_TIME: float = 3.1

func _ready() -> void:
	get_tree().paused = true
	$Timer.start(COUNTDOWN_TIME)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var time = fmod($Timer.time_left, 60)
	if time >= 1:
		$UI/Counter.text = "%1d" % time
	else:
		$UI/Counter.text = "Fly!!"

func _on_timer_timeout() -> void:
	finished.emit()
