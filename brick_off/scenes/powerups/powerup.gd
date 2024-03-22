extends Node2D

const POWERUP_SPEED: float = 300

var kind: PowerupKind:
	set(value): 
		kind = value
		$Sprite2D.texture = kind.texture

func _process(delta: float) -> void:
	position += Vector2.DOWN * POWERUP_SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Paddle:
		body.powerup_picked.emit(kind)
	
	call_deferred("queue_free")
