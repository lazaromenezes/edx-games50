extends Control

var scoreRowScene: PackedScene = preload("res://scenes/high_scores/high_score_row.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 10:
		var score_row: HighScoreRow = scoreRowScene.instantiate()
		score_row.set_score(i + 1, "AAA", (10 - i) * 1000 + 100)
		%ScoreTable.add_child(score_row)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		SceneManager.change_to(SceneManager.TITLE)
