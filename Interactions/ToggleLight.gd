extends Node2D

func interact(guiHandle, player):
	$Light2D.visible = !$Light2D.visible
