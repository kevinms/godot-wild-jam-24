extends StaticBody2D

func interact(gui, player):
	Helper.notify("No dish soap... just use the trash can :'(")

func store_item(object) -> bool:
	Helper.notify("No dish soap... just use the trash can :'(")
	return false

func remove_item() -> Node:
	return null
