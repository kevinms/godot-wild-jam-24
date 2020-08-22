extends Node2D

onready var computer_char_scene = load("res://Interactions/ComputerChar.tscn")

const max_line_length = 36
const char_width = 3.5
const char_height = 7
const max_lines_displayed = 11

var source_lines = []

var current_char = 0
var current_line = 0
var next_hidden_line = 0

func _ready():
	var source = load_text_file("res://source-code.txt")
	
	# Replace tabs with spaces
	source = source.replace("\t", "  ")
	# Split on new lines
	var raw_lines = source.split("\n", true)
	# Split lines based on line length
	var short_lines = []
	for line in raw_lines:
		line = line.strip_edges(false, true)
		while line.length() > max_line_length:
			short_lines.append(line.left(max_line_length))
			line = line.right(max_line_length).strip_edges(true, false)
		short_lines.append(line)
	
	# Loop over all lines
	for line in short_lines:
		var all_chars = []
		var non_space = 0
		for c in line:
			# Create char object
			var obj = computer_char_scene.instance()
			obj.text = c
			
			# Determine if char is typeable (exclude leading/trailing whitespace)
			if c != ' ':
				non_space += 1
			if non_space > 0:
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
	next_hidden_line = i
	set_cursor()

func key_press(letter):
	print(letter)
	
	var line = source_lines[current_line]
	var c = line[current_char]
	
	if c.text != letter:
		return
	
	# They typed the correct character!
	Helper.game_quality += 5
	Helper.computer_letters_typed += 1
	
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
		
		# Delete the current line and shift up
		del_line(line)
		
		# Update the current line to the next one
		current_char = 0
		current_line += 1
		if current_line < source_lines.size():
			line = source_lines[current_line]
		
		# Add the new line at the bottom
		if next_hidden_line < source_lines.size():
			var temp_line = source_lines[next_hidden_line]
			add_line(temp_line, next_hidden_line * char_height)
			next_hidden_line += 1
	
	#TODO: Reset everything if we reach this far.

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
