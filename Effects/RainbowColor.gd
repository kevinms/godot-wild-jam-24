extends Node

var color = Color("d45407")

func rainbow_next_color():
	color.h += 0.035
	
	return color
