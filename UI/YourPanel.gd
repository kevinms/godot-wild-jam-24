extends Node2D

func _process(delta):
	$SleepyGuage.value = Helper.player_sleepiness
	$HungryGuage.value = Helper.player_hungriness

# Called every simulation minute
func _on_Timer_timeout():
	Helper.player_sleepiness = min(
		Helper.player_sleepiness + Helper.player_sleepiness_per_min,
		100.0
	)
	Helper.player_hungriness = min(
		Helper.player_hungriness + Helper.player_hungriness_per_min,
		100.0
	)
