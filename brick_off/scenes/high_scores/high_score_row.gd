class_name HighScoreRow
extends HBoxContainer

func set_score(placement: int, playerName: String, score: int):
	$Position.text = str(placement)
	$Name.text = playerName
	$Score.text = str(score)
