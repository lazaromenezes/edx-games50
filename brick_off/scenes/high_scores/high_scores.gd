extends Control

var score_row_scene: PackedScene = preload("res://scenes/high_scores/high_score_row.tscn")

func _ready() -> void:
	for score in HighScoresManager.high_scores:
		var score_row = score_row_scene.instantiate()
		score_row.set_score(%ScoreTable.get_child_count() + 1, score.name, score.score)
		%ScoreTable.add_child(score_row)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") or event.is_action("ui_accept"):
		SceneManager.change_to(SceneManager.TITLE)
