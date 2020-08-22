extends Node2D

var text: String setget set_text
func set_text(value):
	$Reason.text = value

func change_scene():
	get_tree().change_scene("res://UI/GameOver.tscn")
