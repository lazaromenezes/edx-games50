extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var anti_gravity = 500

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("flap"):
		velocity.y = -anti_gravity
		$AudioStreamPlayer2D.play()
		
	move_and_slide()
