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
			line = line.right(max_line_length)
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

func key_press(letter):
	var line = source_lines[current_line]
	var c = line[current_char]
	
	if c.text == letter:
		c.color = Color(0,1,0)
	
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

func load_text_file(path):
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
	
	var text = file.get_as_text()
	
	file.close()
	return text
