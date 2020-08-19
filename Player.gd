extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const ACCEL = 2000
const MAX_SPEED = 200
const MIN_SPEED = 50
const FRICTION = 1200

enum State {
	NORMAL,
	MINIGAME
}

var state = State.NORMAL

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var guiHandle = $Camera2D/GUI

onready var objectInFront = null

var velocity = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func takeAction(object):
	print("name: ", object.get_name())
	
	if object.get_name() == "Fridge":
		print("Opening the fridge for a snack!")
		guiHandle.updateEnergy(100)

	print(object)
	if object.has_method("interact"):
		object.interact(guiHandle, self)

func _process(delta):
	if state == State.MINIGAME:
		return
	
	if Input.is_action_just_released("ui_accept"):
		if objectInFront != null:
			takeAction(objectInFront)

func _physics_process(delta):
	if state == State.MINIGAME:
		return
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationState.travel("Walk")
		var effectiveSpeed = MAX_SPEED * (guiHandle.getEnergy() / 100.0 )
		if effectiveSpeed < MIN_SPEED:
			effectiveSpeed = MIN_SPEED
		velocity = velocity.move_toward(input_vector*effectiveSpeed, ACCEL * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION*delta)
	
	move_and_slide(velocity)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ActionArea_area_shape_entered(area_id, area, area_shape, self_shape):
	#print(area_id, area, area_shape, self_shape)
	#print(area.get_name())
	objectInFront = area

func _on_ActionArea_area_shape_exited(area_id, area, area_shape, self_shape):
	objectInFront = null

func _on_ActionArea_body_entered(body):
	objectInFront = body

func _on_ActionArea_body_exited(body):
	objectInFront = null
