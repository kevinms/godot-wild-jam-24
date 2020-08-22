extends Node

var player_name: String
var baby_name: String
var spouse_name: String

# Important game stats
var min_remaining: int
var player_sleepiness: float
const player_sleepiness_per_min = 100.0 / (24.0 * 60.0) # Every 24h sim time, sleepiness will be 100%
var player_hungriness: float
const player_hungriness_per_min = 100.0 / (6.0 * 60.0) # Every 6h sim time, hungriness will be 100%
var baby_happiness: float
var baby_sleepiness: float
const baby_sleepiness_per_min = 100.0 / (24.0 * 60.0) # Every 24h sim time, sleepiness will be 100%
var baby_hungriness: float
const baby_hungriness_per_min = 100.0 / (6.0 * 60.0) # Every 6h sim time, hungriness will be 100%
var spouse_happiness: float
var game_quality: float

# Fun statistics
var characters_types: int
var typing_error_rate: int
var trash_disposed: int
var baby_pooped: int
var baby_diapers_changed: int
var baby_bottles_used: int
var pizza_eaten: int

func reset():
	min_remaining = 9 * (24*60)
	player_sleepiness = 0
	player_hungriness = 0
	baby_happiness = 0
	baby_sleepiness = 0
	baby_hungriness = 0
	spouse_happiness = 0
	game_quality = 0
	
	characters_types = 0
	typing_error_rate = 0
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
