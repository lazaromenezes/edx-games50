extends CanvasLayer

signal restarted()
signal quit()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		restarted.emit()
	elif event.is_action_pressed("quit"):
		quit.emit()
