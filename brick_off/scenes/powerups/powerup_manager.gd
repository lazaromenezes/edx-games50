extends Node2D

@export var available_powerups: Array[PowerupKind]
@export var drop_chance: float = 5

var _powerupScene = preload("res://scenes/powerups/powerup.tscn")

func draw_powerup(render_position: Vector2):
	var draw_chance = randi() % 100
	if draw_chance < drop_chance:
		var powerup = _powerupScene.instantiate()
		powerup.kind = available_powerups.pick_random()
		powerup.position = render_position
		call_deferred("add_child", powerup)
