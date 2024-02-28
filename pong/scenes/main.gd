extends Node2D

func _ready():
	reset_game()

func reset_game():
	%Player1.reset_score()
	%Player2.reset_score()
	%Ball.reset()

func _on_court_player_scored(player):
	player.add_score()
	_update_scores()
	%Ball.reset()
	
func _update_scores():
	%Player1Score.text = str(%Player1.score)
	%Player2Score.text = str(%Player2.score)
