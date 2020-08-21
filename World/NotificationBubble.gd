extends Node2D

signal bubble_expired(node)

var msg: String setget set_msg
func set_msg(value: String):
	$PanelContainer/Label.text = value

var timer: float setget set_timer
func set_timer(value: float):
	$Timer.wait_time = value

var height: float setget ,get_height
func get_height() -> float:
	return $PanelContainer.rect_size.y

func _ready():
	var duration = 0.4
	$Tween.interpolate_property(self, "scale", Vector2(0, 0), Vector2.ONE, 2.0, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	$Tween.start()

func _on_Timer_timeout():
	$Tween.interpolate_property(self, "scale", Vector2.ONE, Vector2(0, 0), 0.3, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.connect("tween_all_completed", self, "_on_Tween_scale_zero")
	$Tween.start()

func _on_Tween_scale_zero():
	emit_signal("bubble_expired", self)
