extends Area2D
class_name Goal

signal goal_scored()

func _on_body_entered(_body):
	goal_scored.emit()
