extends StaticBody2D

var typingEffect = load("res://Effects/TypingEffect.tscn")

var quality = 0
var player = null
onready var minigame = $Minigame
var minigame_active = false

const max_line_length = 32
var source: String
var next_letter_index = 0

func load_source_code(path):
	# Check if there is a saved file
	var file = File.new()
	if not file.file_exists(path):
		print("No such file: ", path)
		return ""
	
	# Open existing file
	var err = file.open(path, File.READ)
	if err != OK:
		printerr("Could not open file, error code ", err)
		return ""
	
#	var text = file.get_as_text()
	
	var text = ""
	while not file.eof_reached():
		var line = file.get_line().replace("\t", "  ")
		
		while line.length() > max_line_length:
			print(line.left(max_line_length) + "\n")
			text += line.left(max_line_length) + "\n"
			line = line.right(max_line_length)
		
		print(line + "\n")
		text += line + "\n"
	
	file.close()
	return text

func _ready():
	source = load_source_code("res://source-code.txt")
	
	$Minigame/UntypedCode.text = source
	$Minigame/TypedCode.text = ""

func _input(event):
	if !minigame_active:
		return

	if event is InputEventKey and event.pressed:
		quality += 1
		$Minigame/GameQualityValue.text = str(quality)
		
		# Update the computer screen
		var letter = char(event.unicode)
		if source[next_letter_index] == letter:
			$Minigame/TypedCode.text += letter
			next_letter_index += 1
#		$Minigame/TypedCode.text += source[next_letter_index]
#		next_letter_index += 1
		
		# Spawn effect
		var obj = typingEffect.instance()
		obj.position = $LetterSpawn.position
		obj.text = OS.get_scancode_string(event.scancode)
		add_child(obj)

func interact(gui, actor):
	player = actor
	player.state = player.State.MINIGAME
	
	minigame_active = true
	$Light2D.visible = true
	minigame.visible = true
	$AnimationPlayer.play("Expand")

func _process(delta):
	if !minigame_active:
		return

	if Input.is_action_just_released("ui_cancel"):
		player.state = player.State.NORMAL
		
		minigame_active = false
		minigame.visible = false
		$Light2D.visible = false
		$AnimationPlayer.stop(true)
		return
