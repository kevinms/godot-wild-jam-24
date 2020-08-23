extends StaticBody2D

func interact(gui, player):
	Helper.notify("Who's a good boy? You are.")
	$BarkAudio.play()

func store_item(object) -> bool:
	Helper.notify("Who's a good boy? You are.")
	$BarkAudio.play()
	return false

func remove_item() -> Node:
	return null
