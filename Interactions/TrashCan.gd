extends StaticBody2D

var quality = 0
var minigame_active = false

var stored_item = null

onready var player = Helper.get_player()

func interact(gui, actor):
	start_minigame()

func store_item(object) -> bool:
	if stored_item != null:
		stored_item.queue_free()
	
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
	
	minigame_active = true
	$AnimationPlayer.play("Expand")

func _process(delta):
	if !minigame_active:
		return

	if Input.is_action_just_released("ui_cancel"):
		player.state = player.State.NORMAL
		
		# The player decided to not finish the mini game so they get their trash back.
		var item = remove_item()
		player.store_item(item)
		
		minigame_active = false
		$Minigame.visible = false
		$AnimationPlayer.stop(true)
		return
