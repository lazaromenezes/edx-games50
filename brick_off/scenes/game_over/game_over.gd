extends Control

var scoreRowScene: PackedScene = preload("res://scenes/high_scores/high_score_row.tscn")

func _ready() -> void:
	%Score.text = str(GameState.score)
	%NewHighScore.visible = HighScoresManager.is_new_high_score(GameState.score)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if not %NewHighScore.visible:
			SceneManager.change_to(SceneManager.TITLE)
		else:
			SceneManager.change_to(SceneManager.HIGH_SCORE_ENTRY)
