extends RigidBody2D
class_name Ball

@export var initial_speed = 100
@export var speed_increase = 1.03

var motion = Vector2.ZERO

func _ready():
	reset()

func _physics_process(delta):
	var collision = move_and_collide(motion * delta)
	
	if collision:
		motion = motion.bounce(collision.get_normal())
		
		var collider = collision.get_collider()
		
		if collider is Paddle:
			motion.x *= speed_increase

func reset():
	position = Vector2.ZERO
	
	motion = Vector2.ZERO
	motion.x = initial_speed if randi_range(1, 2) == 1 else -initial_speed
	motion.y = randi_range(-50, 50)
