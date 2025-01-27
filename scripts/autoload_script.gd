extends Node
signal player_hit
#@signal score_updated(new_score)

func emit_player_hit():
	emit_signal("player_hit")

#func emit_score_updated(new_score: int):
	#emit_signal("score_updated", new_score)
