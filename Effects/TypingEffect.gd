extends Node2D

const SPEED = 60
var velocity

var text = "A"

func _ready():
	rotate(rand_range(-PI/4, PI/4))
	velocity = transform.x.normalized() * SPEED
	$Letter.text = text
	$Letter.add_color_override("font_color", RainbowColor.rainbow_next_color())

func _physics_process(delta):
	global_transform.origin += velocity * delta

func _on_Timer_timeout():
	queue_free()
