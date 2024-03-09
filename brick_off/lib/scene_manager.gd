extends Node

const HIGH_SCORE: String = "HIGH_SCORE"
const TITLE: String = "TITLE"
const GAME: String = "GAME"
const PADDLE_SELECT: String = "PADDLE_SELECT"

var highScoresScene: PackedScene = preload ("res://scenes/high_scores/high_scores.tscn")
var titleScreen: PackedScene = preload ("res://scenes/title_screen/title_screen.tscn")
var gameScreen: PackedScene = preload ("res://scenes/game/game.tscn")
var paddleSelect: PackedScene = preload ("res://scenes/paddle_select/paddle_select.tscn")

var scenes: Dictionary = {
	HIGH_SCORE: highScoresScene,
	TITLE: titleScreen,
	GAME: gameScreen,
	PADDLE_SELECT: paddleSelect
}

func change_to(scene: String):
	get_tree().change_scene_to_packed(scenes[scene])
