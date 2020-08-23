extends Node2D

var toggle = true

func _process(delta):
	if Input.is_action_just_pressed("ui_focus_next"):
		
		if toggle:
			$"../HelpPanelAnimation".play("slide")
		else:
			$"../HelpPanelAnimation".play_backwards("slide")
		
		toggle = !toggle
