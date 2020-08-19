extends Node2D

var typeable = false

var text setget set_text, get_text
func set_text(value):
	$Label.text = value
func get_text():
	return $Label.text

var color setget set_color
func set_color(value):
	$Label.add_color_override("font_color", value)
