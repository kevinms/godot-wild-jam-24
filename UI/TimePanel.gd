extends Node2D

func _ready():
	# Every tick one minute passes in game.
	var ticks_per_sec = 1.0 / $Timer.wait_time * Helper.time_scale
	var total_sim_minutes = (9*24*60)
	
	var estimated_real_minutes = total_sim_minutes / ticks_per_sec / 60
	print("Estimated game play length: %s min" % estimated_real_minutes)

func _on_Timer_timeout():
	Helper.min_remaining -= 1 * Helper.time_scale
	
	var d = Helper.min_remaining / (24*60)
	var h = Helper.min_remaining / 60 % 24
	var m = Helper.min_remaining % 60
	
	$TimeLeft.text = "%sd %sh %sm" % [d, h, m]

	if Helper.min_remaining <= 0:
		Helper.trigger_game_over("The game jam is over! Let's see how you did.", true)
