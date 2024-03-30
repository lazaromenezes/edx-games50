extends Node2D

func _on_start_pressed():
	SceneManager.change_to(SceneManager.GAME)

func _on_quit_pressed():
	get_tree().quit()
