extends Control

@export var available_paddles: Array[AtlasTexture]

var _current_paddle: int = 0:
	set(value):
		_current_paddle = value
		%Paddle.texture =available_paddles[value]

func _on_right_button_pressed() -> void:
	if _current_paddle < available_paddles.size() - 1:
		_current_paddle += 1

func _on_left_button_pressed() -> void:
	if _current_paddle > 0:
		_current_paddle -= 1

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		GameState.selected_color = _current_paddle
		SceneManager.change_to(SceneManager.GAME)