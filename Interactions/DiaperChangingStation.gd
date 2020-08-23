extends StaticBody2D

var stored_item = null

onready var player = Helper.get_player()
onready var dirty_diaper_scene = load("res://Furniture/DirtyDiaper.tscn")

func interact(gui, actor):
	if stored_item:
		var item = remove_item()
		player.store_item(item)

func start_minigame():
	if !has_baby():
		Helper.notify("That's not a baby?!")
		return
	
	if !stored_item.poopy:
		Helper.notify("The diaper is clean.")
		return
	
	player.state = player.State.MINIGAME
	$ChangeAudio.play()

func has_baby() -> bool:
	var object = $BabyPosition.get_child(0)
	if object != null && object.is_in_group("baby"):
		return true
	return false

func diaper_changed():
	stored_item.diaper_change()
	
	# Create dirty diaper
	var trash = dirty_diaper_scene.instance()
	var world = player.get_parent()
	world.add_child(trash)
	trash.global_position = $TrashPosition.global_position + Helper.rand_vector(10)
	Helper.trash_generated += 1
	
	Helper.baby_diapers_changed += 1

func store_item(object) -> bool:
	if object == null:
		return false
	
	if stored_item:
		Helper.notify("There is no room on the table.")
		return false
	
	$BabyPosition.add_child(object)
	object.position = Vector2.ZERO
	stored_item = object
	
	start_minigame()
	return true

func remove_item() -> Node:
	if !stored_item:
		return null
	
	var item = stored_item
	$BabyPosition.remove_child(stored_item)
	stored_item = null
	return item

func _on_ChangeAudio_finished():
	diaper_changed()
	
	player.state = player.State.NORMAL
