extends Control

## Color spinner uses an additional color to make this loop
var _colors: Array[Color] = [
	Color8(223, 113, 38, 255),
	Color8(217, 87, 99, 255),
	Color8(95, 205, 228, 255),
	Color8(251, 242, 54, 255),
	Color8(118, 66, 138, 255),
	Color8(153, 229, 80, 255),
	Color8(223, 113, 38, 255)
]

func _ready() -> void:
	_change_letters()

func _on_timer_timeout() -> void:
	_shift_colors()
	_change_letters()

func _shift_colors():
	_colors[0] = _colors[-1]

	for c in range(_colors.size() - 1, 0, -1):
		_colors[c] = _colors[c - 1]

func _change_letters():
	for l in $Letters.get_child_count():
		$Letters.get_child(l).add_theme_color_override("font_color", _colors[l + 1])
