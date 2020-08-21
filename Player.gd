extends KinematicBody2D

const ACCEL = 2000
const MAX_SPEED = 200
const MIN_SPEED = 100
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

var objectsInFront = []

var held_object = null

var velocity = Vector2.ZERO

func takeAction(object):
	print("name: ", object.get_name())
	
	print(object)
	if object.has_method("interact"):
		object.interact(guiHandle, self)
	
	if object.get_name() == "Fridge":
		print("Opening the fridge for a snack!")
		guiHandle.updateEnergy(100)

func pickup_or_drop() -> bool:
	# Drop the object, if we already have one.
	if held_object != null:
		var item = remove_item()
		
		# Drop at station
		for object in objectsInFront:
			if object.is_in_group("container"):
				if object.store_item(item):
					return true
		
		# Drop on floor
		get_parent().add_child(item)
		item.position = position + Vector2.DOWN
		return true
	
	# Try to pick up objects from a container
	for object in objectsInFront:
		if object.is_in_group("container"):
			var item = object.remove_item()
			if item:
				store_item(item)
				return true
	
	# Try to pick up objects in front of us.
	for object in objectsInFront:
		if object.is_in_group("pickupable"):
			var parent = object.get_parent()
			parent.remove_child(object)
			store_item(object)
			return true
	
	return false

func store_item(object):
	if object == null:
		return
	
	# Drop any object we already have.
	if held_object != null:
		var item = remove_item()
		get_parent().add_child(item)
		item.position = position + Vector2.DOWN
	
	add_child(object)
	object.position = Vector2.ZERO
	held_object = object
	
	if object.is_in_group("baby"):
		object.hold()

func remove_item() -> Node:
	var item = held_object
	remove_child(held_object)
	held_object = null
	return item

func _process(delta):
	if state == State.MINIGAME:
		return
	
	if Input.is_action_just_released("ui_accept"):
		if pickup_or_drop():
			print("Picked up object")
			return
		
		if objectsInFront.size() > 0:
			takeAction(objectsInFront[0])
#		if objectInFront != null:
#			takeAction(objectInFront)

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

func object_stack_add(object):
	if !objectsInFront.has(object):
		objectsInFront.append(object)

func object_stack_del(object):
	objectsInFront.erase(object)

func _on_ActionArea_area_shape_entered(area_id, area, area_shape, self_shape):
	#print(area_id, area, area_shape, self_shape)
	#print(area.get_name())
	objectInFront = area
	object_stack_add(area)

func _on_ActionArea_area_shape_exited(area_id, area, area_shape, self_shape):
	objectInFront = null
	object_stack_del(area)

func _on_ActionArea_body_entered(body):
	objectInFront = body
	object_stack_add(body)

func _on_ActionArea_body_exited(body):
	objectInFront = null
	object_stack_del(body)
