extends Node2D

func _ready():
	$UILayer/Control/VBoxContainer/Panel2/VBoxContainer/Quit.visible = not OS.has_feature("web")

func _on_start_pressed():
	SceneManager.change_to(SceneManager.GAME)

func _on_quit_pressed():
	get_tree().quit()
