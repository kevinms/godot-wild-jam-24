extends Node2D


func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	

func _on_request_completed(result, response_code, headers, body):
	get_tree().change_scene("res://HighScores.tscn")


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://MainMenu.tscn")


func _on_Button_pressed():
	var data_to_send = {
		"player_name": Helper.player_name,
		"spouse_name": Helper.spouse_name,
		"baby_name": Helper.baby_name,
		"game_quality": Helper.game_quality
	}
	var query = JSON.print(data_to_send)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request("http://debrislabs.com:6680/newscore", headers, false, HTTPClient.METHOD_POST, query)
