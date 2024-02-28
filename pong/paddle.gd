extends RigidBody2D

@export var speed = 100
@export var player = ""

var movement = Vector2.ZERO

func _process(_delta):
	if Input.is_action_pressed(player + "_up"):
		movement = Vector2.UP * speed
	elif Input.is_action_pressed(player + "_down"):
		movement = Vector2.DOWN * speed
	else:
		movement = Vector2.ZERO

func _physics_process(delta):
	move_and_collide(movement * delta)
