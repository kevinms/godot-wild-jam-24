extends KinematicBody2D

var speed = 40

func _physics_process(delta):
	position.y += speed * delta
