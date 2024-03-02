extends Node2D

const MOVE_SPEED: float = 120
const INITIAL_POSITION: float = 998
const LOOPING_POINT: float = 0

func _process(delta: float) -> void:
	$CaveSprite.position.x -= MOVE_SPEED * delta
	
	if $CaveSprite.position.x < LOOPING_POINT:
		$CaveSprite.position.x = INITIAL_POSITION
