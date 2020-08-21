extends StaticBody2D

var quality = 0
var minigame_active = false

var stored_item = null

onready var player = Helper.get_player()

onready var dirty_diaper_scene = load("res://Furniture/DirtyDiaper.tscn")

func interact(gui, actor):
	start_minigame()

func store_item(object) -> bool:
	$BabyPosition.add_child(object)
	object.position = Vector2.ZERO
	stored_item = object
	
	start_minigame()
	return true

func remove_item() -> Node:
	var item = stored_item
	$BabyPosition.remove_child(stored_item)
	stored_item = null
	return item

func has_baby() -> bool:
	var object = $BabyPosition.get_child(0)
	if object != null && object.is_in_group("baby"):
		return true
	return false

func diaper_changed():
	if !has_baby():
		return
	
	stored_item.diaper_change()
	
	# Create dirty diaper
	var trash = dirty_diaper_scene.instance()
	var world = player.get_parent()
	world.add_child(trash)
	trash.global_position = $TrashPosition.global_position + Helper.rand_vector(10)

func start_minigame():
	if !has_baby():
		$Minigame/Requirement.visible = true
	
	player.state = player.State.MINIGAME
	diaper_changed()
	
	minigame_active = true
	$AnimationPlayer.play("Expand")

func _process(delta):
	if !minigame_active:
		return

	if Input.is_action_just_released("ui_cancel"):
		player.state = player.State.NORMAL
		
		var item = remove_item()
		player.store_item(item)
		
		minigame_active = false
		$Minigame.visible = false
		$AnimationPlayer.stop(true)
		$Minigame/Requirement.visible = false
		return
