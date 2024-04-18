extends Node

func _ready():
	GameEvents.clock_tick.connect(_on_clock_tick)
	GameEvents.game_over.connect(_on_game_over)
	GameEvents.item_selected.connect(_on_item_selected)
	GameEvents.new_level.connect(_on_new_level)
	GameEvents.tile_error.connect(_on_tile_error)
	GameEvents.tile_match.connect(_on_tile_match)

func _on_clock_tick():
	$Sfx/Clock.play()
	
func _on_game_over():
	$Sfx/GameOver.play()
	
func _on_item_selected():
	$Sfx/Select.play()
	
func _on_new_level():
	$Sfx/NewLevel.play()
	
func _on_tile_error():
	$Sfx/Error.play()
	
func _on_tile_match():
	$Sfx/Match.play()
