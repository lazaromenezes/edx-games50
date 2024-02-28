extends RigidBody2D

@export var speed = 100

var movement = Vector2()

func _ready():
	movement.x = speed if randi_range(1, 2) == 1 else -speed
	movement.y = randi_range(-50, 50)

func _physics_process(delta):
	move_and_collide(movement * delta)
