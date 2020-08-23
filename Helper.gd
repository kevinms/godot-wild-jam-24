extends Node

var player_name: String = "Player" setget set_player_name
var baby_name: String = "Baby"  setget set_baby_name
var spouse_name: String = "Spouse"  setget set_spouse_name

func set_player_name(value):
	player_name = value.strip_edges()
	if player_name == "":
		player_name = "Player"
func set_baby_name(value):
	baby_name = value.strip_edges()
	if baby_name == "":
		baby_name = "Baby"
func set_spouse_name(value):
	spouse_name = value.strip_edges()
	if spouse_name == "":
		spouse_name = "Spouse"

# Important game stats displayed by UI
var min_remaining: int
var player_sleepiness: float setget set_player_sleepiness
var player_hungriness: float setget set_player_hungriness
var baby_happiness: float setget set_baby_happiness
var baby_sleepiness: float setget set_baby_sleepiness
var baby_hungriness: float setget set_baby_hungriness
var spouse_happiness: float setget set_spouse_happiness
var game_quality: float
var trash_generated: float
var trash_disposed: int

# !!!!!! ATTENTION !!!!!!
# Everything that effects the important stats should use time_scale... so that time_scale works!
const time_scale = 1.0

const player_sleep_in_bed_min = (5*60) * time_scale # 5h sim time
const player_sleepiness_per_min = 100.0 / (48.0 * 60.0) * time_scale # Every 48h sim time, sleepiness will be 100%
const player_hungriness_per_min = 100.0 / (48.0 * 60.0) * time_scale # Every 24h sim time, hungriness will be 100%
const baby_sleepiness_per_min = 100.0 / (30.0 * 60.0) * time_scale # Every 30h sim time, sleepiness will be 100%
const baby_hungriness_per_min = 100.0 / (24.0 * 60.0) * time_scale # Every 24h sim time, hungriness will be 100%
const spouse_trash_hatred_per_item_per_min = 100.0 / (48.0 * 60.0) * time_scale # Every 24h sim time, happiness will be 0%
const spouse_crying_hatred_per_min = 100.0 / (48.0 * 60.0) * time_scale # Every 24h sim time, happiness will be 0%
const baby_crying_hatred_per_min = 100.0 / (24.0 * 60.0) * time_scale # Every 24h sim time, happiness will be 0%

enum Threshold {
	INCREASING, DECREASING
}

func crossing_thresholds(old, new, thresholds: Array, direction) -> bool:
	for threshold in thresholds:
		if threshold <= max(old, new) and threshold >= min(old, new):
			# It is crossing this threshold.
			var is_decreasing = new < old
			
			# Make sure we are crossing in the correct direction.
			if direction == Threshold.DECREASING and new <= old:
				return true
			if direction == Threshold.INCREASING and new >= old:
				return true
			
			return false
	
	return false

func set_player_sleepiness(value):
#	if crossing_thresholds(player_sleepiness, value, [75], Threshold.INCREASING):
#		Helper.notify("%s is very sleepy -- take a nap to speed up." % Helper.player_name)
	player_sleepiness = clamp(value, 0.0, 100.0)
func set_player_hungriness(value):
#	if crossing_thresholds(player_hungriness, value, [75], Threshold.INCREASING):
#		Helper.notify("%s is very hungry -- eat some food or... die." % Helper.player_name)
	player_hungriness = clamp(value, 0.0, 100.0)
func set_baby_happiness(value):
#	if crossing_thresholds(baby_happiness, value, [25], Threshold.DECREASING):
#		Helper.notify("%s is very unhappy." % Helper.baby_name)
	baby_happiness = clamp(value, 0.0, 100.0)
func set_baby_sleepiness(value):
#	if crossing_thresholds(baby_sleepiness, value, [75], Threshold.INCREASING):
#		Helper.notify("%s is very sleepy -- the crib will help." % Helper.baby_name)
	baby_sleepiness = clamp(value, 0.0, 100.0)
func set_baby_hungriness(value):
#	if crossing_thresholds(baby_hungriness, value, [75], Threshold.INCREASING):
#		Helper.notify("%s is very hungry -- it will starve :'(" % Helper.baby_name)
	baby_hungriness = clamp(value, 0.0, 100.0)
func set_spouse_happiness(value):
#	if crossing_thresholds(spouse_happiness, value, [25], Threshold.DECREASING):
#		Helper.notify("%s is very unhappy." % Helper.spouse_name)
	spouse_happiness = clamp(value, 0.0, 100.0)

# Indirectly important stats (other stats are adjusted based on these)


# Fun statistics
var computer_letters_typed: int
var computer_keys_pressed: int
var baby_pooped: int
var baby_diapers_changed: int
var baby_bottles_used: int
var pizza_eaten: int #TODO: can't eat pizza currently :(

var game_over_triggered = false

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
	
	game_over_triggered = false

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

func trigger_game_over(reason: String):
	if game_over_triggered:
		print("Game is already over.")
		return
	
	# Set GameOverReason scene text.
	var reason_node = get_tree().get_root().find_node("GameOverReason", true, false)
	reason_node.text = reason
	
	# Start the game over animation.
	var animation: AnimationPlayer = get_tree().get_root().find_node("StartMinigameAnimation", true, false)
	animation.play("GameOver")
	
	game_over_triggered = true
