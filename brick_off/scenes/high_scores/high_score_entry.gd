extends Control

func _ready():
	%Score.text = str(GameState.score)

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		var player_name = %NameEntry.get_name_entry()
		HighScoresManager.save_score(player_name, GameState.score)
		SceneManager.change_to(SceneManager.HIGH_SCORE)
