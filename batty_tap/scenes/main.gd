extends Node2D

@export var spawn_limits: Vector2

var crystalScene: PackedScene = preload("res://scenes/crystal/crystal.tscn")

func _ready() -> void:
	_schedule_spawn()

func _schedule_spawn():
	$SpawnTimer.start(randf_range(spawn_limits.x, spawn_limits.y))

func _spawn_crystal() -> void:
	var crystal = crystalScene.instantiate()
	crystal.position = Vector2(528, 428)
	$Crystals.add_child(crystal)

func _on_spawn_timer_timeout() -> void:
	_spawn_crystal()
	_schedule_spawn()
