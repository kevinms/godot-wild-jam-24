extends Node2D

const arrow_rotation_speed = PI/200
var arrow_size = 1.0

const kick_strength = 100.0
var kicked: bool
var active: bool

onready var trash_scene = load("res://Interactions/TrashMinigame/TrashRigidBody.tscn")
var trash: RigidBody2D

func _ready():
	$Goal.monitoring = false

func start():
	$Goal.monitoring = true
	reset_kick()
	active = true

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
		
		kicked = true
		$ResetTimer.start()

func _on_ResetTimer_timeout():
	reset_kick()


func _on_Goal_body_entered(body):
	print ("aaaaaaaaaaaa ", body.name)
	
	$CheerAudio.play()
	$CheerParticles.emitting = true
	$CelebrationTimer.start()


func _on_CelebrationTimer_timeout():
	active = false
