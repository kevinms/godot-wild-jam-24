extends StaticBody2D

var items_disposed = 0
var minigame_active = false

var stored_item = null
var item_layer_save = 0
var item_mask_save = 0
var item_removable = false

onready var player = Helper.get_player()
onready var minigame = get_tree().get_root().find_node("TrashThrowing", true, false)
onready var animation: AnimationPlayer = get_tree().get_root().find_node("StartMinigameAnimation", true, false)

#func interact(gui, actor):
#	start_minigame()

var player_won: bool

# Every trash can will receive the event?!
func _on_Minigame_player_won():
	print("Player won yay")
	items_disposed += 1
	$Minigame/GameQualityValue.text = str(items_disposed)
	player_won = true
	item_removable = false

func store_item(object) -> bool:
	if object == null:
		return false
	
	if stored_item != null:
		if !has_baby():
			stored_item.queue_free()
	
	item_layer_save = object.collision_layer
	item_mask_save = object.collision_mask
	object.collision_layer = 0
	object.collision_mask = 0
	$TrashPosition.add_child(object)
	object.position = Vector2.ZERO
	stored_item = object
	item_removable = true
	
	start_minigame()
	return true

func remove_item() -> Node:
	if !item_removable:
		return null
	
	var item = stored_item
	$TrashPosition.remove_child(stored_item)
	stored_item = null
	item.collision_layer = item_layer_save
	item.collision_mask = item_mask_save
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
	
	player_won = false
	minigame.connect("player_won", self, "_on_Minigame_player_won")

	minigame_active = true
	$AnimationPlayer.play("Expand")

func stop_minigame():
	player.state = player.State.NORMAL
	
	minigame.stop()
	animation.play_backwards("StartTrashThrowing")
	
	minigame.disconnect("player_won", self, "_on_Minigame_player_won")
	
	minigame_active = false
	#$Minigame.visible = false
	$AnimationPlayer.play_backwards("Expand")

func _process(delta):
	if !minigame_active:
		return
	
	if Input.is_action_just_released("ui_cancel"):
		if !player_won:
			# The player decided to not finish the mini game so they get their trash back.
			var item = remove_item()
			player.store_item(item)
		
		stop_minigame()
		return
	
	if !minigame.active:
		stop_minigame()
