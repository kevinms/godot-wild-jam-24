extends Node2D

onready var baby = Helper.get_baby()

func _process(delta):
	$HappyGuage.value = Helper.baby_happiness
	$SleepyGuage.value = Helper.baby_sleepiness
	$HungryGuage.value = Helper.baby_hungriness

# Called every simulation minute
func _on_Timer_timeout():
	Helper.baby_sleepiness += Helper.baby_sleepiness_per_min
	Helper.baby_hungriness += Helper.baby_hungriness_per_min

	if baby.is_happy():
		Helper.baby_happiness += Helper.baby_crying_hatred_per_min *2.0
	else:
		Helper.baby_happiness -= Helper.baby_crying_hatred_per_min
