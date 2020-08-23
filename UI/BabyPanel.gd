extends Node2D

var social_services_might_come = false

onready var baby = Helper.get_baby()

func _process(delta):
	$HappyGuage.value = Helper.baby_happiness
	$SleepyGuage.value = Helper.baby_sleepiness
	$HungryGuage.value = Helper.baby_hungriness
	
	if social_services_might_come:
		$EndPanel/Value.text = "%.2f" % $SocialServicesTimer.time_left
	
	if baby.poopy:
		$PoopEmoji.visible = true
	else:
		$PoopEmoji.visible = false

# Called every simulation minute
func _on_Timer_timeout():
	if baby.is_sleeping():
		Helper.baby_sleepiness -= Helper.baby_sleepiness_per_min
		# Wake up the baby if rested.
		if Helper.baby_sleepiness <= 0:
			baby.wakeup()
	else:
		Helper.baby_sleepiness += Helper.baby_sleepiness_per_min
		
		# The baby doesn't get hungry while sleeping (makes the game easier)
		Helper.baby_hungriness += Helper.baby_hungriness_per_min
	
	if baby.is_happy():
		Helper.baby_happiness += Helper.baby_crying_hatred_per_min *2.0
	else:
		Helper.baby_happiness -= Helper.baby_crying_hatred_per_min
	
	# Check if social services might come
	if Helper.baby_happiness <= 0:
		if !social_services_might_come:
			Helper.notify("%s is very unhappy and social services will come." % Helper.baby_name)
			social_services_might_come = true
			$SocialServicesTimer.start()
			$EndPanel.visible = true
	else:
		social_services_might_come = false
		$SocialServicesTimer.stop()
		$EndPanel.visible = false


func _on_SocialServicesTimer_timeout():
	Helper.trigger_game_over("Social services came and took %s." % [Helper.baby_name], false)
