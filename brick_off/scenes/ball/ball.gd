extends CharacterBody2D

var _is_served: bool = false
var initial_position: Vector2
var size: Vector2

@export var max_paddle_influence: float = 50
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
			var collider = collision.get_collider()

			var bouncing_velocity = collision.get_normal()

			if collider is Paddle:
				SfxPlayer.paddle_hit.play()
				position.y = initial_position.y
				
				if collision.get_collider_velocity() != Vector2.ZERO:
					velocity.x += _calculate_influence(collision, collider)

			elif collider is Brick:
				_increase_speed()
			else:
				SfxPlayer.wall_hit.play()

			velocity = velocity.bounce(bouncing_velocity)

func serve() -> void:
	velocity.y = initial_speed * Vector2.UP.y
	velocity.x = randf_range(-200, 200)

	_is_served = true

func reset() -> void:
	position = initial_position
	velocity = Vector2.ZERO
	_is_served = false

func _increase_speed():
	if abs(velocity.y) < max_speed:
		velocity.y *= increase_factor
		
func _calculate_influence(collision, collider):
	var collider_size = collider.size.x
	var collider_x = to_global(collider.position).x
	var ball_x = to_global(position).x
	
	var influence_factor = abs(ball_x - collider_x) / (collider_size / 2)
	
	return max_paddle_influence * influence_factor * collision.get_collider_velocity().normalized().x
