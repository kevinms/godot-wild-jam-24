extends Node2D

onready var initial_arrow_rotation = $ArrowPivot.rotation
onready var initial_can_position = $Can.position
const arrow_rotation_speed = PI/200
var arrow_size = 1.0

const kick_strength = 175.0
var kicked: bool
var active: bool

onready var trash_scene = load("res://Interactions/TrashMinigame/TrashRigidBody.tscn")
var trash: RigidBody2D

var game_over: bool
signal player_won

func start():
	# Reset arrow orientation
	$ArrowPivot.rotation = initial_arrow_rotation
	
	# Pick a new trash can location
	var new_pos =initial_can_position + (Vector2.RIGHT * (rand_range(-58, 58)))
	$Can.position = new_pos
	$CanBack.position = new_pos
	
	reset_kick()
	active = true
	game_over = false

func stop():
	active = false

	for child in $TrashNodes.get_children():
		child.queue_free()

func reset_kick():
	$ArrowPivot.scale = Vector2.ONE
	arrow_size = 1.0
	
	trash = trash_scene.instance()
	trash.position = $ArrowPivot.position
	trash.rotation = $ArrowPivot.rotation
	$TrashNodes.add_child(trash)
	
	kicked = false

func _process(delta):
	if !active:
		return

	if !kicked:
		charge_kick()

func charge_kick():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector = input_vector.normalized()
	
	# Rotate arrow
	if input_vector.x > 0:
		$ArrowPivot.rotate(arrow_rotation_speed)
	if input_vector.x < 0:
		$ArrowPivot.rotate(-arrow_rotation_speed)
	
	if Input.is_action_pressed("ui_accept"):
		arrow_size = min(arrow_size+0.005, 2.0)
		$ArrowPivot.scale = Vector2(arrow_size, arrow_size)
	
	if Input.is_action_just_released("ui_accept"):
		$Player.frame = 0
		$Player.play("default")
		var strength_modifier = kick_strength * 0.9 * (arrow_size - 1.0)
		var impulse = $ArrowPivot.transform.x.normalized() * (kick_strength + strength_modifier)
		trash.apply_impulse(Vector2.LEFT, impulse)
		trash.apply_torque_impulse(1.0)
		
		kicked = true
		$ResetTimer.start()

func _on_ResetTimer_timeout():
	reset_kick()


func _on_Goal_body_entered(body):
	print ("aaaaaaaaaaaa ", body.name)
	if game_over:
		return

	emit_signal("player_won")
	game_over = true
	
	$CheerAudio.play()
	$Can/CheerParticles.emitting = true
	$CelebrationTimer.start()


func _on_CelebrationTimer_timeout():
	stop()
