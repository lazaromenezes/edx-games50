extends StaticBody2D
class_name Paddle

@export var speed = 100
@export var player = ""

var score = 0
var motion = Vector2.ZERO

func _process(_delta):
	if Input.is_action_pressed(player + "_up"):
		motion = Vector2.UP * speed
	elif Input.is_action_pressed(player + "_down"):
		motion = Vector2.DOWN * speed
	else:
		motion = Vector2.ZERO

func _physics_process(delta):
	move_and_collide(motion * delta)

func add_score():
	score += 1

func reset_score():
	score = 0

