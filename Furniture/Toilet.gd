extends StaticBody2D

func interact(gui, player):
	Helper.notify("That smells.")

func store_item(object) -> bool:
	Helper.notify("That smells.")
	return false

func remove_item() -> Node:
	return null
