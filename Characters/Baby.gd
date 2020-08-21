extends StaticBody2D

enum State {
	EAT, POOP, SLEEP, CRY, OBSERVE
}
var state = State.SLEEP

# Conditions
var hungry = false
var poopy = false
var lonely = false
var sleepy = false

func _ready():
	set_state(State.OBSERVE)

func feed():
	if !hungry:
		return
	
	hungry = false
	set_state(State.EAT)

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

func lullaby():
	if !sleepy:
		return
	
	sleepy = false
	set_state(State.SLEEP)


func _on_ConditionTimer_timeout():
	# There is chance of pooping at nearly any time.
	if !poopy and randf() < 0.01:
		poopy = true
		set_state(State.POOP)
	
	match state:
		State.SLEEP:
			# Chance something bad will happen.
			if randf() < 0.1:
				# Time to wake up and be unhappy.
				var coin = randf()
				if coin < 0.5:
					hungry = true
					set_state(State.CRY)
				else:
					poopy = true
					set_state(State.POOP)
		State.OBSERVE:
			var dist = distance_to_player()
			if dist > 125:
				lonely = true
				Helper.notify("Baby is lonely.")
				set_state(State.CRY)
			
			# Make sure the baby is upset.
			if hungry || poopy || lonely || sleepy:
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
