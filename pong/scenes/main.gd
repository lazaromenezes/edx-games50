extends Node2D

@export var winning_score: int = 5

const PRESS_ENTER: String = "Press [Enter]\nto start"
const SERVING: String = "Press [Enter]\nto serve"

enum State{STOPPED, PLAYING, SERVING}

signal state_changed(new_state)

var current_state: State = State.STOPPED:
	set(value):
		current_state = value
		state_changed.emit(value)

var last_scored: Paddle

func allow_serve():
	current_state = State.SERVING
	
func stop():
	current_state = State.STOPPED
	
func play():
	current_state = State.PLAYING

func _ready():
	state_changed.connect(_on_state_changed)

func _on_court_player_scored(player):
	last_scored = player
	
	player.add_score()
	
	_update_scores()
	_check_victory(player)

func _update_scores():
	%Player1Score.text = str(%Player1.score)
	%Player2Score.text = str(%Player2.score)
	
func _on_state_changed(state):
	match(state):
		State.STOPPED:
			%Ball.reset()
			%Player1.reset_score()
			%Player2.reset_score()
			_update_scores()
			%InfoLabel.text = PRESS_ENTER
		State.SERVING:
			%InfoLabel.text = SERVING
			%Ball.reset()
		State.PLAYING:
			%InfoLabel.text = " \n "
			if last_scored == null:
				%Ball.serve(0)
			else:
				%Ball.serve(1 if last_scored == %Player2 else -1)
			
func _input(event):
	if event.is_action_pressed("start") and current_state == State.STOPPED:
		allow_serve()
		
	if event.is_action_pressed("serve") and current_state == State.SERVING:
		play()
		
	if event.is_action_pressed("reset") and current_state != State.STOPPED:
		stop()

func _check_victory(player):
	if player.score == winning_score:
		await get_tree().create_timer(2).timeout
		stop()
	else:
		allow_serve()
