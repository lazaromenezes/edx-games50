extends Node2D

const MOVE_SPEED: float = 20
const INITIAL_POSITION: float = 1000
const LOOPING_POINT: float = 0

func _process(delta: float) -> void:
	$CaveSprite.position.x -= MOVE_SPEED * delta
	
	if $CaveSprite.position.x < LOOPING_POINT:
		$CaveSprite.position.x = INITIAL_POSITION
