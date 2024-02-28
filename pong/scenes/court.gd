extends Node2D

signal player_scored(player)

@export var left_player: Paddle
@export var right_player: Paddle

func _on_goal_left_goal_scored():
	player_scored.emit(right_player)
	
func _on_goal_right_goal_scored():
	player_scored.emit(left_player)
