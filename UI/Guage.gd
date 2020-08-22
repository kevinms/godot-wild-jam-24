extends TextureProgress

export var flatline: float = 100
export var red_range: float = 33
var pulsing = false

var base_color = Color("b5ff00")

func pulse_start():
	if pulsing:
		return
	pulsing = true
	
	$AnimationPlayer.play("pulse")

func pulse_stop():
	if !pulsing:
		return
	pulsing = false
	
	$AnimationPlayer.stop(true)

func _process(delta):
	if value == flatline:
		pulse_start()
	else:
		pulse_stop()
	
	var dist = abs(flatline - value)
	if dist < red_range:
		tint_progress = Color("ff0000")
	else:
		tint_progress = Color("ffffff00")
