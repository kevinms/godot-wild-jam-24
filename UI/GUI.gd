extends Control

onready var dayLabel = $CanvasLayer/CenterContainer/DayLabel
onready var remainingLabel = $CanvasLayer/CenterContainer/RemainingLabel

func play_day_transition():
	var d = Helper.min_remaining / (24*60)
	var h = Helper.min_remaining / 60 % 24
	var m = Helper.min_remaining % 60
	
	dayLabel.text = "Day: %d" % [9-d]
	remainingLabel.text = "%d days %d hours %d min remaining" % [d, h, m]
	
	$AnimationPlayer.play("EndOfDay")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "EndOfDay":
		Helper.player_sleepiness = 0
