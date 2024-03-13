extends Control

func _ready() -> void:
	GameState.score = 0
	%StartButton.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit(0)

func _on_high_score_button_pressed() -> void:
	SceneManager.change_to(SceneManager.HIGH_SCORE)

func _on_start_button_pressed() -> void:
	SceneManager.change_to(SceneManager.PADDLE_SELECT)
