extends Node2D

onready var computer_char_scene = load("res://Interactions/ComputerChar.tscn")

const max_line_length = 32
const char_width = 5
const char_height = 10
const max_lines_displayed = 8

var source_lines = []

var current_char = 0
var current_line = 0
var next_line = 0

func _ready():
	var source = load_text_file("res://source-code.txt")
	
	# Replace tabs with spaces
	source = source.replace("\t", "..")
	# Split on new lines
	var raw_lines = source.split("\n", true)
	# Split lines based on line length
	var short_lines = []
	for line in raw_lines:
		while line.length() > max_line_length:
			short_lines.append(line.left(max_line_length))
			line = line.right(max_line_length).strip_edges(true, false)
		short_lines.append(line)
	
	# Loop over all lines
	for line in short_lines:
		var all_chars = []
		for c in line:
			# Create char object
			var obj = computer_char_scene.instance()
			obj.text = c
			
			# Determine if char is typeable (exclude leading/trailing whitespace)
			obj.typeable = true
			
			all_chars.append(obj)
		source_lines.append(all_chars)
	
	# Add N lines, starting at line offset, to the scene
	var i = 0
	var y = 0
	while i < source_lines.size() and i < max_lines_displayed:
		add_line(source_lines[i], y)
		y += char_height
		print(i)
		i += 1
	
	current_line = 0
	next_line = i
	set_cursor()

func key_press(letter):
	print(letter)
	
	var line = source_lines[current_line]
	var c = line[current_char]
	
	if c.text != letter:
		return
	
	c.color = Color(0,1,0)
	
	# Find next typeable character!
	current_char += 1
	while current_line < source_lines.size():
		print("cl: ", current_line)
		
		# Look on the current line
		while current_char < line.size():
			print("cc: ", current_char)
			if line[current_char].typeable:
				print(line[current_char].text)
				set_cursor()
				return
			current_char += 1
		
		current_char = 0
		current_line += 1
		del_line(line)
		line = source_lines[current_line]
	
	#TODO: Reset everything if we reach this far.
	
	# As lines are typed:
	#   Remove top line
	#   Shift all chars up one row
	#   Add a new row at the bottom

func add_line(line: Array, y: float):
	var x = 0
	for c in line:
			c.position = Vector2(x, y)
			$TextPosition.add_child(c)
			x += char_width

func del_line(line: Array):
	for c in line:
		c.queue_free()
	shift_up()

func shift_up():
	$TextPosition.translate(Vector2.UP * char_height)

func set_cursor():
	$TextPosition/ComputerCursor.position = Vector2(current_char * char_width, current_line * char_height)

func load_text_file(path):
	var file = File.new()
	
	# Open file
	var err = file.open(path, File.READ)
	if err != OK:
		printerr("Could not open file, error code ", err)
		return ""
	
	var text = file.get_as_text()
	
	file.close()
	return text
