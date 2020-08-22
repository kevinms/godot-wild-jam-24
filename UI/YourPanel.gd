extends Node2D

func _process(delta):
	$SleepyGuage.value = Helper.player_sleepiness
	$HungryGuage.value = Helper.player_hungriness

# Called every simulation minute
func _on_Timer_timeout():
	Helper.player_sleepiness += Helper.player_sleepiness_per_min
	Helper.player_hungriness += Helper.player_hungriness_per_min
