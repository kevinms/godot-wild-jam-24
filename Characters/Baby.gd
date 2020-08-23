extends StaticBody2D

enum State {
	EAT, POOP, SLEEP, CRY, OBSERVE
}
var state = State.SLEEP

func _ready():
	set_state(State.OBSERVE)
	reset_poop_timer(true)

# Conditions
var poopy = false
var lonely = false

# Conditions controlled by UI meters
func is_sleepy():
	return Helper.baby_sleepiness >= 100.0
func is_hungry():
	return Helper.baby_hungriness >= 100.0


##
# Methods for checking baby's state
##
func is_happy():
	if is_hungry() || poopy || lonely || is_sleepy():
		return false
	return true
	#return state != State.CRY and !poopy

func is_sleeping():
	return state == State.SLEEP


##
# Methods for changing baby's state
##
func feed():
	set_state(State.EAT)

func lullaby():
	set_state(State.SLEEP)

func wakeup():
	set_state(State.OBSERVE)

func diaper_change():
	if !poopy:
		return
	
	$StinkEffect.stop()
	$StinkEffect.visible = false
	poopy = false
	set_state(State.OBSERVE)

func hold():
	if !lonely:
		return
	
	Helper.notify("I'm here baby. You are so cute! Yes you are.")
	
	lonely = false
	set_state(State.OBSERVE)

func reset_poop_timer(first=false):
	if first:
		$PoopTimer.wait_time = 10.0
	else:
		$PoopTimer.wait_time = rand_range(30.0, 60.0)
	$PoopTimer.start()

func _on_PoopTimer_timeout():
	if !is_sleeping():
		set_state(State.POOP)
		poopy = true
	
	# Pick the next time
	reset_poop_timer()

func _on_ConditionTimer_timeout():
	match state:
		State.OBSERVE:
			var dist = distance_to_player()
			if dist > 145:
				lonely = true
				Helper.notify("Baby is lonely.")
				set_state(State.CRY)
	
	if state != State.CRY:
		# Make sure the baby is upset, if it should be.
		if is_hungry() || poopy || lonely || is_sleepy():
			set_state(State.CRY)

func distance_to_player() -> float:
	for player in get_tree().get_nodes_in_group("player"):
		return (player.global_position - global_position).length()
	return 0.0

func set_state(new_state):
	match state:
		State.POOP:
			# There is no stopping poop.
			pass
		State.CRY:
			$CryAudio.stop()
			$CryEffect.stop()
			$CryEffect.visible = false
		State.SLEEP:
			$SnoreAudio.stop()
			$SleepEffect.stop()
			$SleepEffect.visible = false
		State.EAT:
			$EatAudio.stop()
	
	match new_state:
		State.POOP:
			Helper.baby_pooped += 1
			$PoopAudio.play()
		State.CRY:
			$CryAudio.play()
			$CryEffect.play()
			$CryEffect.visible = true
		State.SLEEP:
			Helper.notify("Baby is asleep.")
			$SnoreAudio.play()
			$SleepEffect.play()
			$SleepEffect.visible = true
		State.EAT:
			$EatAudio.play()
	
	state = new_state

func _on_PoopAudio_finished():
	$StinkEffect.play()
	$StinkEffect.visible = true
	Helper.notify("Baby pooped.")
	set_state(State.CRY)


func _on_EatAudio_finished():
	set_state(State.OBSERVE)
