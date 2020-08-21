extends Node

func get_player():
	for player in get_tree().get_nodes_in_group("player"):
		return player
