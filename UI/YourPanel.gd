extends Node2D

var player_might_die = false

func _process(delta):
	$SleepyGuage.value = Helper.player_sleepiness
	$HungryGuage.value = Helper.player_hungriness
	
	if player_might_die:
		$EndPanel/Value.text = "%.2f" % $StarvationTimer.time_left

# Called every simulation minute
func _on_Timer_timeout():
	Helper.player_sleepiness += Helper.player_sleepiness_per_min
	Helper.player_hungriness += Helper.player_hungriness_per_min
	
	# Check if player might die
	if Helper.player_hungriness >= 100.0:
		if !player_might_die:
			Helper.notify("You will starve to death.")
			player_might_die = true
			$StarvationTimer.start()
			$EndPanel.visible = true
	else:
		player_might_die = false
		$StarvationTimer.stop()
		$EndPanel.visible = false

func _on_StarvationTimer_timeout():
	Helper.trigger_game_over("%s starved to death." % [Helper.player_name])
