extends StaticBody2D

var minigame_active = false

onready var player = Helper.get_player()
onready var minigame = get_tree().get_root().find_node("FridgeMinigame", true, false)
onready var animation: AnimationPlayer = get_tree().get_root().find_node("StartMinigameAnimation", true, false)

onready var pizza_scene = load("res://Furniture/Pizza.tscn")
onready var babybottle_scene = load("res://Furniture/BabyBottle.tscn")

func interact(gui, actor):
	start_minigame()

func start_minigame():
	player.state = player.State.MINIGAME
	
	minigame.start()
	animation.play("StartFridgeMinigame")

	minigame_active = true
	#$AnimationPlayer.play("Expand")

func stop_minigame():
	player.state = player.State.NORMAL
	
	minigame.stop()
	animation.play_backwards("StartFridgeMinigame")
	
	minigame_active = false
	#$Minigame.visible = false
	#$AnimationPlayer.play_backwards("Expand")

func _process(delta):
	if !minigame_active:
		return
	
	if Input.is_action_just_released("ui_cancel"):
		# The player decided to not finish the mini game.
		stop_minigame()
		return
	
	if !minigame.active:
		# The player completed the mini game -- give the food they won.
		var item = null
		match minigame.which_item:
			"Pizza":
				item = pizza_scene.instance()
			"BabyBottle":
				item = babybottle_scene.instance()
		player.store_item(item)
		stop_minigame()
