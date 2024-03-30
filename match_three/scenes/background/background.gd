extends CanvasLayer

#@export var scroll_speed: float = 80

var _initial_position: float
#var _loop_position: float = 0

func _ready():
	_initial_position = $BackgroundImage.position.x

#func _physics_process(delta: float) -> void:
	#$BackgroundImage.position.x -= scroll_speed * delta
	#
	#if $BackgroundImage.position.x <= _loop_position:
		#$BackgroundImage.position.x = _initial_position

