extends StaticBody2D

var quality = 0
var player = null
var minigame_active = false

func interact(gui, actor):
	player = actor
	player.state = player.State.MINIGAME
	
	minigame_active = true
	$AnimationPlayer.play("Expand")

func _process(delta):
	if !minigame_active:
		return

	if Input.is_action_just_released("ui_cancel"):
		player.state = player.State.NORMAL
		
		minigame_active = false
		$Minigame.visible = false
		$AnimationPlayer.stop(true)
		return
