extends Node2D

@export var spawn_limits: Vector2

var crystalScene: PackedScene = preload("res://scenes/crystal/crystal.tscn")
var _score: int = 0

func _ready() -> void:
	$GameOverLayer.process_mode = Node.PROCESS_MODE_DISABLED

func _schedule_spawn():
	$SpawnTimer.start(randf_range(spawn_limits.x, spawn_limits.y))

func _spawn_crystal() -> void:
	var crystal = crystalScene.instantiate()
	crystal.position = Vector2(528, 428)
	crystal.hit.connect(_on_hit)
	crystal.passed.connect(_on_passed)
	$Crystals.add_child(crystal)

func _on_spawn_timer_timeout() -> void:
	_spawn_crystal()
	_schedule_spawn()

func _on_hit():
	$Audio/HurtAudio.play()
	$GameOverLayer.show()
	get_tree().paused = true

func _on_passed():
	_score += 1
	%ScoreLabel.text = str(_score)
	$Audio/PassedAudio.play()

func _on_game_over_layer_restarted() -> void:
	get_tree().reload_current_scene()

func _on_game_over_layer_quit() -> void:
	get_tree().quit(0)

func _on_countdown_layer_finished() -> void:
	if get_tree().paused:
		get_tree().paused = false
		
	$GameOverLayer.hide()
	_score = 0
	%ScoreLabel.text = str(_score)
	$CountdownLayer.hide()
	$GameOverLayer.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	_schedule_spawn()
	
func _on_crystal_destroy_area_area_exited(area: Area2D) -> void:
	area.get_parent().call_deferred("destroy")
