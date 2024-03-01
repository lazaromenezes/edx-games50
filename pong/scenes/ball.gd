extends CharacterBody2D
class_name Ball

@export var initial_speed = 100
@export var speed_increase = 1.03

var motion = Vector2.ZERO
var stopped: bool = true

func _ready():
	reset()

func _physics_process(delta):
	if not stopped:
		_move_ball(delta)

func _move_ball(delta):
	var collision = move_and_collide(motion * delta)

	if collision:
		motion = motion.bounce(collision.get_normal())
		
		var collider = collision.get_collider()
	
		if collider is Paddle:
			motion.x *= speed_increase
			motion.y *= randf_range(1, 1.05)
			$PaddleHit.play()
		else:
			$WallHit.play()
			

func reset():
	position = Vector2.ZERO
	motion = Vector2.ZERO
	stopped = true

func serve(direction):
	if direction == 0:
		motion.x = initial_speed if randi_range(1, 2) == 1 else -initial_speed
	else:
		motion.x = direction * initial_speed
		
	motion.y = randi_range(-60, 60)
	stopped = false
