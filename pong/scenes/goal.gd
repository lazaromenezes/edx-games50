extends Area2D
class_name Goal

signal goal_scored()

func _on_body_entered(_body):
	$GoalAudio.play()
	goal_scored.emit()
