extends Resource
class_name PowerupKind

@export var texture: Texture2D
@export var effect_script: GDScript

func apply_effect(game):
	if not effect_script:
		return
		
	var effect = effect_script.new()
	effect.apply(game)
