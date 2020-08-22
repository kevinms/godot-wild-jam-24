extends Node2D

onready var platform_scene = load("res://Interactions/FridgeMinigame/Platform.tscn")

var max_platforms = 9

var min_speed = 40
var max_speed = 50

var max_dist_apart = 90

var last_spawn = null
var height_between: float

var elapsed_time: float
var active: bool
var which_item: String

var game_over: bool
signal player_won

func _ready():
	stop()

func start():
	active = true
	$Player.active = true
	elapsed_time = 0
	which_item = ""
	game_over = false
	
	$Pizza/Sprite.modulate = Color("#ffffff")
	$BabyBottle/Sprite.modulate = Color("#ffffff")
	
	var dist = ($Spawn.global_position - $Despawn.global_position).length()
	height_between = dist / max_platforms
	
	# Create one platform
	var y = (max_platforms-1) * height_between
	for i in range(max_platforms):
		spawn(y)
		y -= height_between
#	var platform = platform_scene.instance()
#	$Spawn.add_child(platform)
#	platform.position = Vector2(rand_range(-120, 120), 0.0)
#	last_spawn = platform

func stop():
	active = false
	$Player.active = false
	
	for child in $Spawn.get_children():
		child.queue_free()

func spawn(y: float = 0.0):
	var platform = platform_scene.instance()
	$Spawn.add_child(platform)
	
#	if elapsed_time < 10.0:
#		platform.speed = max_speed
#	else:
#		platform.speed = lerp(min_speed, max_speed, (elapsed_time-10.0) / 10.0)
	
	# Overall bounds of the game
	var minx = -120
	var maxx = 120
	
	# Make sure it's close-ish to the last spawn.x
	if last_spawn:
		minx = last_spawn.position.x - max_dist_apart
		maxx = last_spawn.position.x + max_dist_apart
		
		# Shift spawn region to keep it in the bounds.
		if last_spawn.position.x - max_dist_apart < -120:
			minx = -120
			maxx = minx + (max_dist_apart*2)
		elif last_spawn.position.x + max_dist_apart > 120:
			maxx = 120
			minx = maxx - (max_dist_apart*2)
	
	var x = rand_range(minx, maxx)
	
	#x = clamp(x, -120, 120)
	platform.position = Vector2(x, y)
	
	last_spawn = platform

func _process(delta):
	if !active:
		return
	
	elapsed_time += delta
	
	for child in $Spawn.get_children():
		if child.global_position.y > $Despawn.global_position.y:
			child.queue_free()
	
	if $Spawn.get_child_count() < max_platforms:
		if last_spawn.position.y >= height_between:
			spawn()


func _on_Pizza_body_entered(body):
	if game_over:
		return
	
	if body.is_in_group("fridge-player"):
		$Pizza/WinAnimation.play("Win")
		which_item = "Pizza"
		
		emit_signal("player_won")
		game_over = true

func _on_BabyBottle_body_entered(body):
	if game_over:
		return
	
	if body.is_in_group("fridge-player"):
		$BabyBottle/WinAnimation.play("Win")
		which_item = "BabyBottle"
		
		emit_signal("player_won")
		game_over = true

func _on_BabyBottle_WinAnimation_animation_finished(anim_name):
	stop()

func _on_Pizza_WinAnimation_animation_finished(anim_name):
	stop()
