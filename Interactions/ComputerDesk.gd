extends StaticBody2D

var typingEffect = load("res://Effects/TypingEffect.tscn")

var quality = 0
var player = null
onready var minigame = $Minigame
var minigame_active = false

func _input(event):
	if !minigame_active:
		return

	if event is InputEventKey and event.pressed:
		quality += 1
		$Minigame/GameQualityValue.text = str(quality)
		
		# Update the computer screen
		var letter = char(event.unicode)
#		if source[next_letter_index] == letter:
#			$Minigame/TypedCode.text += letter
#			next_letter_index += 1
#		$Minigame/TypedCode.text += source[next_letter_index]
#		next_letter_index += 1
		$Minigame/ComputerScreen.key_press(letter)
		
		# Spawn effect
		var obj = typingEffect.instance()
		obj.position = $LetterSpawn.position
		obj.text = OS.get_scancode_string(event.scancode)
		add_child(obj)

func interact(gui, actor):
	player = actor
	player.state = player.State.MINIGAME
	
	minigame_active = true
	$Light2D.visible = true
	$AnimationPlayer.play("Expand")

func _process(delta):
	if !minigame_active:
		return

	if Input.is_action_just_released("ui_cancel"):
		player.state = player.State.NORMAL
		
		minigame_active = false
		minigame.visible = false
		$Light2D.visible = false
		$AnimationPlayer.stop(true)
		return
