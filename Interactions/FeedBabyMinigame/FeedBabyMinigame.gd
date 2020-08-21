extends Node2D

var active = false

func start():
	active = true

func stop():
	$ArmAnimation.stop()
	$JawAnimation.stop()
	$ArmSwingTimer.stop()
	$JawOpenTimer.stop()
	active = false

func _on_ArmAnimation_animation_finished(anim_name):
	$ArmSwingTimer.wait_time = rand_range(0.8, 3.0)
	$ArmSwingTimer.start()

func _on_JawAnimation_animation_finished(anim_name):
	$JawOpenTimer.wait_time = rand_range(0.1, 2.0)
	$JawOpenTimer.start()

func _on_ArmSwingTimer_timeout():
	# Play again with a random speed.
	$ArmAnimation.playback_speed = rand_range(0.5, 1.0)
	$ArmAnimation.play("Wave")

func _on_JawOpenTimer_timeout():
	# Play again with a random speed.
	$JawAnimation.playback_speed = rand_range(0.5, 3.0)
	$JawAnimation.play("Move")


func _on_Goal_body_exited(body):
	if body.name != "BottleArm":
		return
	
	stop()
