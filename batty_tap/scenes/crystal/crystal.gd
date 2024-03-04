extends Node2D

signal hit()
signal passed()

const MIN_GAP: float = 170
const MAX_GAP: float = 270

const CRYSTAL_HEIGHT: float = 400
const OFFSET: float = 1

@export var speed: float = 100

func _ready() -> void:
	var gap: float = randf_range(MIN_GAP, MAX_GAP)
	$Gap/CollisionShape2D.shape.size.y = gap
	var crystal_y = CRYSTAL_HEIGHT / 2.0 + OFFSET + gap / 2.0
	$Lower.position.y = crystal_y
	$Upper.position.y = -crystal_y
	position.y = get_viewport_rect().size.y / 2 + randf_range(-130, 130)

func _process(delta: float) -> void:
	position.x -= speed * delta

func _on_body_entered_hit_area(_body: Node2D) -> void:
	hit.emit()

func _on_body_passed(_body: Node2D) -> void:
	passed.emit()
