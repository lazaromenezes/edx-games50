extends VBoxContainer

const A: int = 65
const Z: int = 90

var letter: int = A:
	set(value):
		letter = value
		%Letter.text = char(value)

var selected: bool = false:
	set(value):
		selected = value
		modulate = Color.GREEN_YELLOW if selected else Color.WHITE

func _unhandled_input(event):
	if selected:
		if event.is_action_pressed("ui_up"):
			if letter < Z:
				letter += 1 
			else:
				letter = A
		if event.is_action_pressed("ui_down"):
			if letter > A:
				letter -= 1 
			else:
				letter = Z
