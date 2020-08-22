extends StaticBody2D

var stored_item = null

onready var player = Helper.get_player()
onready var trash_scene = load("res://Furniture/DinnerWareTrash.tscn")

func interact(gui, actor):
	if stored_item:
		var item = remove_item()
		player.store_item(item)

func start_minigame():
	if !has_food():
		Helper.notify("That's not food?!")
		return
	
	player.state = player.State.MINIGAME
	$EffectAudio.play()

func has_food() -> bool:
	var object = $ItemPosition.get_child(0)
	if object != null && object.is_in_group("food"):
		return true
	return false

func store_item(object) -> bool:
	if stored_item:
		Helper.notify("There is no room on the table.")
		return false
	
	$ItemPosition.add_child(object)
	object.position = Vector2.ZERO
	stored_item = object
	
	start_minigame()
	return true

func remove_item() -> Node:
	if !stored_item:
		return null
	var item = stored_item
	$ItemPosition.remove_child(stored_item)
	stored_item = null
	$DinnerWare.visible = true
	return item

func food_eaten():
	stored_item.queue_free()
	
	# Create dirty dish
	var trash = trash_scene.instance()
	$ItemPosition.add_child(trash)
	stored_item = trash
	Helper.trash_generated += 1
	
	$DinnerWare.visible = false
	
	Helper.player_hungriness = 0.0
	Helper.pizza_eaten += 1

func _on_EffectAudio_finished():
	food_eaten()
	
	player.state = player.State.NORMAL
