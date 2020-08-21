extends KinematicBody2D

var position_speed = 200
var retreat_speed = 300
var attack_speed = 500
var attack_pos: Vector2

onready var initial_pos = position

enum State {
	POSITION, ATTACK, RETREAT, PAUSE
}
var state = State.PAUSE

func reset():
	state = State.POSITION
	position = initial_pos

func pause():
	state = State.PAUSE

func _physics_process(delta):
	match state:
		State.POSITION:
			var dir = Vector2.ZERO
			dir.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
			dir = dir.normalized()
			
			position += dir * (position_speed * delta)
			position.y = clamp(position.y, -100, 100)
			
			if Input.is_action_just_pressed("ui_accept"):
				state = State.ATTACK
				attack_pos = position
		State.ATTACK:
			var velocity = Vector2.RIGHT * attack_speed
			var hit = move_and_collide(velocity * delta)
			if hit:
				state = State.RETREAT
		State.RETREAT:
			position = position.move_toward(attack_pos, retreat_speed * delta)
			if position == attack_pos:
				state = State.POSITION
