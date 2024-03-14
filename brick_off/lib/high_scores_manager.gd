extends Node

const HIGH_SCORE_FILE: String = "user://scores"

var high_scores: Array[HighScoreEntry]

func _init():
	if not FileAccess.file_exists(HIGH_SCORE_FILE):
		high_scores = _dummy_high_scores()
		_write_scores()
	else:
		high_scores = []
		var file = FileAccess.open(HIGH_SCORE_FILE, FileAccess.READ)
		while file.get_position() < file.get_length():
			var score_line = file.get_csv_line()
			high_scores.push_back(HighScoreEntry.new(score_line[0], int(score_line[1])))
			
		file.close()

func _dummy_high_scores():
	var scores: Array[HighScoreEntry] = []
	for i in 10:
		var score = (10 - i) * 1000 + 100
		scores.push_back(HighScoreEntry.new("AAA", score))
		
	return scores

func _reducer(acc, hs): 
	return str(acc) + str(hs)

func is_new_high_score(score):
	return score > high_scores[-1].score

func save_score(name, score):
	var new_entry = HighScoreEntry.new(name, score)
	
	for i in high_scores.size():
		if high_scores[i].score < new_entry.score:
			high_scores.insert(i, new_entry)
			break
			
	high_scores = high_scores.slice(0, 10)
	_write_scores()

func _write_scores():
	var file = FileAccess.open(HIGH_SCORE_FILE, FileAccess.WRITE)
	var score_string = high_scores.reduce(_reducer, "")
	file.store_string(score_string)
	file.close()

class HighScoreEntry:
	var name: String
	var score: int
	
	func _init(_name, _score):
		self.name = _name
		self.score = _score
		
	func _to_string():
		return "%s,%d\n" % [name, score]
