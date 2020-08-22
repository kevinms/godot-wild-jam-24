extends StaticBody2D

func interact(gui, player):
	Helper.min_remaining -= Helper.player_sleep_in_bed_min
	Helper.player_sleepiness = 0
	gui.play_day_transition()
