extends StaticBody2D

func interact(gui, player):
	Helper.notify("No hand soap... hard to find cleaning supplies these days.")

func store_item(object) -> bool:
	Helper.notify("No hand soap... hard to find cleaning supplies these days")
	return false

func remove_item() -> Node:
	return null
