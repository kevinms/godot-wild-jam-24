extends Node2D

func _process(delta):
	$Value.text = str(Helper.game_quality)
