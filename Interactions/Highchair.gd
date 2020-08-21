extends KinematicBody2D

var baby = null
var food = null
var baby_layer_save = 0
var food_layer_save = 0
var baby_mask_save = 0
var food_mask_save = 0

var minigame_active = false

onready var player = Helper.get_player()
onready var minigame = get_tree().get_root().find_node("FeedBabyMinigame", true, false)
onready var animation: AnimationPlayer = get_tree().get_root().find_node("StartMinigameAnimation", true, false)

onready var empty_bottle_scene = load("res://Furniture/EmptyBottle.tscn")

var player_won: bool

func _on_Minigame_player_won():
	print("Player won yay")
	player_won = true
	
	#TODO Update global stats
	
	# Remove food item
	if food:
		food.queue_free()
		food = null
	
	# Create new empty bottle trash
	var trash = empty_bottle_scene.instance()
	var world = player.get_parent()
	world.add_child(trash)
	trash.global_position = $TrashPosition.global_position  + Helper.rand_vector(10)

func store_item(object) -> bool:
	if object == null:
		return false
	
	if object.is_in_group("baby"):
		baby = object
		$BabyPosition.add_child(object)
		object.position = Vector2.ZERO
		if !food:
			Helper.notify("Baby food is in the fridge.")
		baby_layer_save = object.collision_layer
		object.collision_layer = 0
		object.collision_mask = 0
	elif food:
		# We already have something in the food slot.
		Helper.notify("There is already something on the highchair.")
		return false
	else:
		if !object.is_in_group("babyfood"):
			Helper.notify("That is not baby food -- check the fridge")
		food = object
		$FoodPosition.add_child(object)
		object.position = Vector2.ZERO
		food_layer_save = object.collision_layer
		object.collision_layer = 0
		object.collision_mask = 0
	
	if baby and food and food.is_in_group("babyfood"):
		start_minigame()
	
	return true

func remove_item() -> Node:
	if food:
		var item = food
		$FoodPosition.remove_child(food)
		food.collision_layer = food_layer_save
		food.collision_mask = food_mask_save
		food = null
		return item
	
	if baby:
		var item = baby
		$BabyPosition.remove_child(baby)
		baby.collision_layer = baby_layer_save
		baby.collision_mask = baby_mask_save
		baby = null
		return item
	
	return null

func start_minigame():
	player.state = player.State.MINIGAME
	
	minigame.start()
	animation.play("StartFeedBabyMinigame")
	
	player_won = false
	minigame.connect("player_won", self, "_on_Minigame_player_won")

	minigame_active = true

func stop_minigame():
	player.state = player.State.NORMAL
	
	minigame.stop()
	animation.play_backwards("StartFeedBabyMinigame")
	
	minigame.disconnect("player_won", self, "_on_Minigame_player_won")
	
	minigame_active = false

func _process(delta):
	if !minigame_active:
		return
	
	if Input.is_action_just_released("ui_cancel"):
		if !player_won:
			# The player decided to not finish the mini game so they get an item back.
			var item = remove_item()
			player.store_item(item)
		
		stop_minigame()
		return
	
	if !minigame.active:
		# The player completed the mini game.
		stop_minigame()
