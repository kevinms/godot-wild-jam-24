extends Node2D

func _process(delta):
	$HappyGuage.value = Helper.baby_happiness
	$SleepyGuage.value = Helper.baby_sleepiness
	$HungryGuage.value = Helper.baby_hungriness

# Called every simulation minute
func _on_Timer_timeout():
	Helper.baby_sleepiness = min(
		Helper.baby_sleepiness + Helper.baby_sleepiness_per_min,
		100.0
	)
	Helper.baby_hungriness = min(
		Helper.baby_hungriness + Helper.baby_hungriness_per_min,
		100.0
	)
