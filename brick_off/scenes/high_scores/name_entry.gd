extends HBoxContainer

const TOTAL_LETTERS = 3

var _current_letter = 0

var _letter_entries: Array[Node]

func _ready():
	_letter_entries = get_children()
	_letter_entries[_current_letter].selected = true

func _unhandled_input(event):
	if event.is_action_pressed("ui_right"):
		_move_next()
	if event.is_action_pressed("ui_left"):
		_move_back()
		
func _move_next():
	if _current_letter < TOTAL_LETTERS - 1:
		_letter_entries[_current_letter].selected = false
		_current_letter += 1
		_letter_entries[_current_letter].selected = true
		
func _move_back():
	if _current_letter > 0:
		_letter_entries[_current_letter].selected = false
		_current_letter -= 1
		_letter_entries[_current_letter].selected = true

func get_name_entry():
	return _letter_entries\
	.map(func (l): return char(l.letter))\
	.reduce(func (_name, letter): return _name + letter, "")
	
