extends Node

var player_name: String
var baby_name: String
var spouse_name: String

const time_scale = 1.0

# Important game stats displayed by UI
var min_remaining: int
var player_sleepiness: float setget set_player_sleepiness
const player_sleepiness_per_min = 100.0 / (24.0 * 60.0) * time_scale # Every 24h sim time, sleepiness will be 100%
var player_hungriness: float setget set_player_hungriness
const player_hungriness_per_min = 100.0 / (12.0 * 60.0) * time_scale # Every 12h sim time, hungriness will be 100%
var baby_happiness: float setget set_baby_happiness
var baby_sleepiness: float setget set_baby_sleepiness
const baby_sleepiness_per_min = 100.0 / (24.0 * 60.0) * time_scale # Every 24h sim time, sleepiness will be 100%
var baby_hungriness: float setget set_baby_hungriness
const baby_hungriness_per_min = 100.0 / (12.0 * 60.0) * time_scale # Every 12h sim time, hungriness will be 100%
var spouse_happiness: float setget set_spouse_happiness
const spouse_trash_hatred_per_item_per_min = 100.0 / (24.0 * 60.0) * time_scale # Every 24h sim time, sleepiness will be 100%
const spouse_crying_hatred_per_min = 100.0 / (24.0 * 60.0) * time_scale # Every 24h sim time, sleepiness will be 100%
const baby_crying_hatred_per_min = 100.0 / (24.0 * 60.0) * time_scale # Every 24h sim time, sleepiness will be 100%
var game_quality: float
var trash_generated: float
var trash_disposed: int

func set_player_sleepiness(value):
	player_sleepiness = clamp(value, 0.0, 100.0)
func set_player_hungriness(value):
	player_hungriness = clamp(value, 0.0, 100.0)
func set_baby_happiness(value):
	baby_happiness = clamp(value, 0.0, 100.0)
func set_baby_sleepiness(value):
	baby_sleepiness = clamp(value, 0.0, 100.0)
func set_baby_hungriness(value):
	baby_hungriness = clamp(value, 0.0, 100.0)
func set_spouse_happiness(value):
	spouse_happiness = clamp(value, 0.0, 100.0)

# Indirectly important stats (other stats are adjusted based on these)


# Fun statistics
var computer_letters_typed: int
var computer_keys_pressed: int
var baby_pooped: int
var baby_diapers_changed: int
var baby_bottles_used: int
var pizza_eaten: int #TODO: can't eat pizza currently :(

func reset():
	min_remaining = 9 * (24*60)
	player_sleepiness = 0
	player_hungriness = 0
	baby_happiness = 100.0
	baby_sleepiness = 0
	baby_hungriness = 0
	spouse_happiness = 100.0
	game_quality = 0
	
	computer_letters_typed = 0
	computer_keys_pressed = 0
	baby_pooped = 0
	baby_diapers_changed = 0
	baby_bottles_used = 0
	pizza_eaten = 0
	trash_generated = 0
	trash_disposed = 0

func get_player():
	for node in get_tree().get_nodes_in_group("player"):
		return node

func get_baby():
	for node in get_tree().get_nodes_in_group("baby"):
		return node

func rand_vector(radius: float) -> Vector2:
	var x = rand_range(-radius, radius)
	var y = rand_range(-radius, radius)
	return Vector2(x, y)

signal send_notification(msg)

func notify(msg = "This is a notification message."):
	emit_signal("send_notification", msg)
