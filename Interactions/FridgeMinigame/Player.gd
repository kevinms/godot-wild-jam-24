extends KinematicBody2D

export (int) var speed = 120
export (int) var jump_speed = -275
export (int) var gravity = 800

export (float, 0, 1.0) var friction = 0.3
export (float, 0, 1.0) var acceleration = 0.25

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

var velocity = Vector2.ZERO
var can_jump = true

func _physics_process(delta):
	var dir = Vector2.ZERO
	dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	dir = dir.normalized()
	
	if dir != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", dir)
		animationTree.set("parameters/Walk/blend_position", dir)
		animationState.travel("Walk")
		
		velocity.x = lerp(velocity.x, dir.x * speed, acceleration)
	else:
		animationState.travel("Idle")
		velocity.x = lerp(velocity.x, 0, friction)
	
	
	velocity.y += gravity * delta
	
	var snap = Vector2.ZERO
	
	if is_on_floor():
		can_jump = true
		snap = Vector2.DOWN * 16
	
	if Input.is_action_just_pressed("ui_accept") && can_jump:
		velocity.y = jump_speed
		can_jump = false
		snap = Vector2.ZERO
	
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP)
