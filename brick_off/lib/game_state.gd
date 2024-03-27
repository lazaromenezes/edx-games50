extends Node

signal score_updated(score)

var selected_color: int = 0
var score: int = 0:
	set(value):
		score = value
		score_updated.emit(score)
