extends Node2D

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	$HTTPRequest.request("http://debrislabs.com:6680/scores")

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if !json or !json.result:
		return
	print(json.result)
	var rank = 1
	for s in json.result["scores"]:
		$HBoxContainer/Rank.text += "\n" + str(rank)
		$"HBoxContainer/Game Quality".text += "\n" + str(s["game_quality"])
		$"HBoxContainer/Player Name".text += "\n" + s["player_name"]
		$"HBoxContainer/Spouse Name".text += "\n" + s["spouse_name"]
		$"HBoxContainer/Baby Name".text += "\n" + s["baby_name"]
		
		#var node = Label.new()
		#node.text = "Rank: %s Game Quality: %s Player Name: %s Spouse Name: %s Baby Name: %s" % [ str(rank), s["game_quality"], s["player_name"], s["spouse_name"], s["baby_name"]]
		#$Control/VBoxContainer.add_child(node)
		#node.set_owner(get_tree().get_edited_scene_root())
		rank += 1


func _on_Button_pressed():
	get_tree().change_scene("res://MainMenu.tscn")
