extends RefCounted
class_name Tile

var color_id: int
var shape_id: int
var texture: AtlasTexture
var shiny: bool = false

@warning_ignore("shadowed_variable")
func _init(color_id: int, shape_id: int, texture: AtlasTexture):
	self.color_id = color_id
	self.shape_id = shape_id
	self.texture = texture

func is_equal(other: Tile) -> bool:
	if other == null:
		return false
		
	return other.color_id == self.color_id

static func from(tile: Tile):
	return Tile.new(tile.color_id, tile.shape_id, tile.texture)
