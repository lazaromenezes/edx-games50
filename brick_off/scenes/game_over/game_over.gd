extends Control

var scoreRowScene: PackedScene = preload("res://scenes/high_scores/high_score_row.tscn")

func _ready() -> void:
	%Score.text = str(GameState.score)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		SceneManager.change_to(SceneManager.TITLE)
