extends Node

const HIGH_SCORE: String = "HIGH_SCORE"
const HIGH_SCORE_ENTRY: String = "HIGH_SCORE_ENTRY"
const TITLE: String = "TITLE"
const GAME: String = "GAME"
const PADDLE_SELECT: String = "PADDLE_SELECT"
const GAME_OVER: String = "GAME_OVER"

var highScoresScene: PackedScene = preload ("res://scenes/high_scores/high_scores.tscn")
var highScoresEntryScene: PackedScene = preload ("res://scenes/high_scores/high_score_entry.tscn")
var titleScreen: PackedScene = preload ("res://scenes/title_screen/title_screen.tscn")
var gameScreen: PackedScene = preload ("res://scenes/game/game.tscn")
var paddleSelect: PackedScene = preload ("res://scenes/paddle_select/paddle_select.tscn")
var gameOver: PackedScene = preload("res://scenes/game_over/game_over.tscn")

var scenes: Dictionary = {
	HIGH_SCORE: highScoresScene,
	TITLE: titleScreen,
	GAME: gameScreen,
	PADDLE_SELECT: paddleSelect,
	GAME_OVER: gameOver,
	HIGH_SCORE_ENTRY: highScoresEntryScene
}

func change_to(scene: String):
	get_tree().call_deferred("change_scene_to_packed", scenes[scene])
