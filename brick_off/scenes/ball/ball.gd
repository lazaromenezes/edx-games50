extends CharacterBody2D

var _is_served: bool = false
var initial_position: Vector2
var size: Vector2

@export var initial_speed: float = 300
@export var max_speed: float = 1000
@export var increase_factor: float = 1.02
@export var available_balls: Array[AtlasTexture]

func _ready() -> void:
	size = $Sprite2D.texture.region.size * scale

	$Sprite2D.texture = available_balls[GameState.selected_color]

func _physics_process(delta: float) -> void:
	if _is_served:
		var collision = move_and_collide(velocity * delta)

		if collision:
			
			if(collision.get_collider() is Paddle):
				position.y = initial_position.y
			
			velocity = velocity.bounce(collision.get_normal())

			_increase_speed()
			
	else:
		velocity = Vector2.ZERO

func serve() -> void:
	velocity.y = initial_speed * Vector2.UP.y
	velocity.x = randf_range(-200, 200)

	_is_served = true

func reset() -> void:
	position = initial_position

func _increase_speed():
	if abs(velocity.y) < max_speed:
		velocity.y *= increase_factor