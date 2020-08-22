extends StaticBody2D

var stored_item = null

onready var player = Helper.get_player()
onready var trash_scene = load("res://Furniture/DinnerWareTrash.tscn")

func interact(gui, actor):
	if stored_item:
		var item = remove_item()
		player.store_item(item)

func start_minigame():
	player.state = player.State.MINIGAME
	$EffectAudio.play()

func has_baby() -> bool:
	var object = $ItemPosition.get_child(0)
	if object != null && object.is_in_group("baby"):
		return true
	return false

func store_item(object) -> bool:
	if stored_item:
		Helper.notify("Something else is already in the crib.")
		return false
	
	$ItemPosition.add_child(object)
	object.position = Vector2.ZERO
	stored_item = object
	
	if !has_baby():
		Helper.notify("That's not a baby?!")
		return true
	
	start_minigame()
	return true

func remove_item() -> Node:
	if !stored_item:
		return null
	
	if has_baby():
		stored_item.wakeup()
	
	var item = stored_item
	$ItemPosition.remove_child(stored_item)
	stored_item = null
	return item

func _on_EffectAudio_finished():
	stored_item.lullaby()
	
	player.state = player.State.NORMAL
