extends CanvasLayer

signal displayed()

const TEXT_TEMPLATE: String = "LEVEL %d"

func _ready():
	var tween = create_tween()
	tween.tween_property(self, "transform:origin:y", 100, 0.5)
	tween.tween_property(self, "transform:origin:y", 500, 0.5).set_delay(0.5)
	tween.tween_callback(displayed.emit)
	tween.tween_callback(queue_free)

func set_level(level: int):
	$PanelContainer/Label.text = TEXT_TEMPLATE % level
