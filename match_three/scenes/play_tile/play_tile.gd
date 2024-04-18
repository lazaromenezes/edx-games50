extends Area2D
class_name PlayTile

signal selected(play_tile: Node2D)

var _selected: bool:
	set(value):
		_selected = value
		$Sprite.material.set_shader_parameter("Selected", value)
		if _selected: 
			selected.emit(self)

var tile: Tile: 
	set(value): 
		tile = value
		$Sprite.texture = tile.texture
		$Sprite.material.set_shader_parameter("Shiny", value.shiny)

func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("select_tile"):
		GameEvents.item_selected.emit()
		_selected = true

func _on_mouse_entered():
	$Sprite.material.set_shader_parameter("Hovered", true)

func _on_mouse_exited():
	$Sprite.material.set_shader_parameter("Hovered", false)
