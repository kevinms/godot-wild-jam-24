extends Node2D


func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	if Helper.player_won == false:
		$submit_high_scores.visible = false

func _on_request_completed(result, response_code, headers, body):
	get_tree().change_scene("res://HighScores.tscn")


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://MainMenu.tscn")
	
	#TODO: Update title to reflect reason.
	if Helper.player_won:
		$Title.text = "Game jam entry completed!"
	else:
		$Title.text = Helper.game_over_reason
	
	$Player/Value.text = Helper.player_name
	$Spouse/Value.text = Helper.spouse_name
	$Baby/Value.text = Helper.baby_name
	
	$GameQuality/Value.text = str(Helper.game_quality)
	
	var errorPercent = 0.0
	if Helper.computer_keys_pressed > 0:
		errorPercent = Helper.computer_letters_typed / Helper.computer_keys_pressed * 100.0
	
	$StatValues.text = "%d\n%.2f\n%d\n%d" % [Helper.computer_letters_typed, errorPercent, Helper.trash_generated, Helper.trash_disposed]
	$StatValues2.text = "%d\n%d\n%d\n%d" % [Helper.baby_pooped, Helper.baby_diapers_changed, Helper.baby_bottles_used, Helper.pizza_eaten]

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
