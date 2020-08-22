extends Node2D

var active = false
var game_over: bool
signal player_won

func start():
	active = true
	$BottleArm.reset()
	$ArmAnimation.play("Wave")
	$JawAnimation.play("Move")
	$BabyAnimation.play("Move")
	game_over = false

func stop():
	$ArmAnimation.stop()
	$JawAnimation.stop()
	$ArmSwingTimer.stop()
	$JawOpenTimer.stop()
	$BottleArm.pause()
	active = false

func celebrate():
	$BabyAnimation.stop()
	$BottleArm.pause()
	
	$ArmSwingTimer.wait_time = 0.001
	$JawOpenTimer.wait_time = 0.001
	$ArmAnimation.playback_speed = 6.0
	$JawAnimation.playback_speed = 3.0
	
	$ArmAnimation.play("Wave")
	$JawAnimation.play("Move")
	
	$CelebrationTimer.start()
	$CelebrationAudio.play()

func _on_ArmAnimation_animation_finished(anim_name):
	if !game_over:
		$ArmSwingTimer.wait_time = rand_range(0.8, 3.0)
	$ArmSwingTimer.start()

# How long the jaw stays open
func _on_JawAnimation_animation_finished(anim_name):
	if !game_over:
		$JawOpenTimer.wait_time = rand_range(0.5, 1.0)
	$JawOpenTimer.start()

func _on_ArmSwingTimer_timeout():
	if !game_over:
		$ArmAnimation.playback_speed = rand_range(0.5, 1.0)
	$ArmAnimation.play("Wave")

# How fast the jaw closes
func _on_JawOpenTimer_timeout():
	if !game_over:
		$JawAnimation.playback_speed = rand_range(0.5, 1.0)
	$JawAnimation.play("Move")

func _on_Goal_body_entered(body):
	if body.name != "BottleArm":
		return
	
	if game_over:
		return
	
	emit_signal("player_won")
	game_over = true
	
	celebrate()


func _on_CelebrationTimer_timeout():
	stop()
