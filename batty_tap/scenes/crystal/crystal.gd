extends Node2D

signal hit()
signal passed()

const MIN_GAP: float = 170
const MAX_GAP: float = 270

const CRYSTAL_HEIGHT: float = 448
const CRYSTAL_WIDTH: float = 58
const OFFSET: float = 1

@export var speed: float = 100
@export var available_cristals: Array[CrystalTexture] = []

func _ready() -> void:
	_draw_crystal($Upper/Sprite2D, $Upper/PointLight2D, available_cristals.pick_random())
	_draw_crystal($Lower/Sprite2D, $Lower/PointLight2D, available_cristals.pick_random())
	
	var gap: float = randf_range(MIN_GAP, MAX_GAP)
	$Gap/CollisionShape2D.shape.size.y = gap
	var crystal_y = CRYSTAL_HEIGHT / 2.0 + OFFSET + gap / 2.0
	$Lower.position.y = crystal_y
	$Upper.position.y = -crystal_y
	position.y = get_viewport_rect().size.y / 2 + randf_range(-130, 130)

func _process(delta: float) -> void:
	position.x -= speed * delta
	
	if to_global(position).x < -CRYSTAL_WIDTH:
		_destroy()

func _on_body_entered_hit_area(_body: Node2D) -> void:
	hit.emit()

func _on_body_passed(_body: Node2D) -> void:
	passed.emit()
	
func _destroy():
	call_deferred("queue_free")
	
func _draw_crystal(crystal: Sprite2D, light: PointLight2D, texture: CrystalTexture):
	crystal.texture = texture.image
	light.color = texture.emission
