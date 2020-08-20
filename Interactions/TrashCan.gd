extends StaticBody2D

var items_disposed = 0
var minigame_active = false

var stored_item = null

onready var player = Helper.get_player()
onready var minigame = get_tree().get_root().find_node("TrashThrowing", true, false)
onready var animation: AnimationPlayer = get_tree().get_root().find_node("StartMinigameAnimation", true, false)

#func interact(gui, actor):
#	start_minigame()

func store_item(object) -> bool:
	if object == null:
		return false
	
	if stored_item != null:
		stored_item.queue_free()
	
	object.collision_layer = 0
	object.collision_mask = 0
	$TrashPosition.add_child(object)
	object.position = Vector2.ZERO
	stored_item = object
	
	start_minigame()
	return true

func remove_item() -> Node:
	var item = stored_item
	$TrashPosition.remove_child(stored_item)
	stored_item = null
	return item

func has_baby() -> bool:
	if stored_item != null && stored_item.is_in_group("baby"):
		return true
	return false

func start_minigame():
	if has_baby():
		print("You lose...")
	
	player.state = player.State.MINIGAME
	
	minigame.start()
	animation.play("StartTrashThrowing")

	minigame_active = true
	$AnimationPlayer.play("Expand")

func stop_minigame():
	player.state = player.State.NORMAL
	
	minigame.stop()
	animation.play_backwards("StartTrashThrowing")
	
	minigame_active = false
	#$Minigame.visible = false
	$AnimationPlayer.play_backwards("Expand")

func _process(delta):
	if !minigame_active:
		return
	
	if Input.is_action_just_released("ui_cancel"):
		# The player decided to not finish the mini game so they get their trash back.
		var item = remove_item()
		player.store_item(item)
		
		stop_minigame()
		return
	
	if !minigame.active:
		# The player completed the mini game.
		items_disposed += 1
		$Minigame/GameQualityValue.text = str(items_disposed)
		stop_minigame()
