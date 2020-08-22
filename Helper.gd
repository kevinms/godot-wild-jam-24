extends Node

var player_name: String
var baby_name: String
var spouse_name: String

var characters_types: int
var typing_error_rate: int
var game_quality: int
var trash_disposed: int
var baby_pooped: int
var baby_diapers_changed: int
var baby_bottles_used: int
var pizza_eaten: int

func reset():
	characters_types = 0
	typing_error_rate = 0
	game_quality = 0
	trash_disposed = 0
	baby_pooped = 0
	baby_diapers_changed = 0
	baby_bottles_used = 0
	pizza_eaten = 0

func get_player():
	for player in get_tree().get_nodes_in_group("player"):
		return player

func rand_vector(radius: float) -> Vector2:
	var x = rand_range(-radius, radius)
	var y = rand_range(-radius, radius)
	return Vector2(x, y)

signal send_notification(msg)

func notify(msg = "This is a notification message."):
	emit_signal("send_notification", msg)
