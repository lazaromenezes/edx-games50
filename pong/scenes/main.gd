extends Node2D

func _ready():
	reset_game()

func reset_game():
	pass

func _on_court_player_scored(player):
	player.add_score()
	%Ball.reset()
