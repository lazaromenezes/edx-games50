extends Node

const GAME: String = "GAME"
const TITLE: String = "TITLE"

var titleScreen: PackedScene = preload ("res://scenes/title_screen/title_screen.tscn")
var gameScreen: PackedScene = preload ("res://scenes/game/game.tscn")

var scenes: Dictionary = {
	TITLE: titleScreen,
	GAME: gameScreen,
}

func change_to(scene: String):
	get_tree().call_deferred("change_scene_to_packed", scenes[scene])

