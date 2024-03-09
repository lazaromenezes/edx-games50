extends CharacterBody2D

@export var available_balls: Array[AtlasTexture]

func _ready() -> void:
	$Sprite2D.texture = available_balls[GameState.selected_color]
