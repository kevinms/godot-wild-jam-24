extends Node

enum ColorState{
	RED, GREEN, BLUE
}
var color_state = ColorState.RED
var color = Color("d45407")

func rainbow_next_color():
	match color_state:
		ColorState.RED:
			if color.r8 >= 212:
				if color.b8 > 7:
					color.b8 = max(color.b8 - 50, 7)
				else:
					color_state = ColorState.GREEN
			else:
				color.r8 = min(color.r8 + 50, 212)
		ColorState.GREEN:
			if color.g8 >= 212:
				if color.r8 > 7:
					color.r8 = max(color.r8 - 50, 7)
				else:
					color_state = ColorState.BLUE
			else:
				color.g8 = min(color.g8 + 50, 212)
		ColorState.BLUE:
			if color.b8 >= 212:
				if color.g8 > 7:
					color.g8 = max(color.g8 - 50, 7)
				else:
					color_state = ColorState.RED
			else:
				color.b8 = min(color.b8 + 50, 212)
	
	return color
