extends Node2D

func _process(delta):
	$HappyGuage.value = Helper.spouse_happiness
