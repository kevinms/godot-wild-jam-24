extends Node2D

enum States {
	MENU_1,
	BACKSTORY_1,
	PLAYER_NAMING,
	SPOUSE_NAMING,
	BABY_NAMING,
	BACKSTORY_2,
	TUTORIAL
}
var state = States.MENU_1
onready var menu1 = $menu_1
onready var backstory_1 = $backstory_1
onready var playerNaming = $playerNaming
onready var spouseNaming = $spouseNaming
onready var babyNaming = $babyNaming
onready var backstory_2 = $backstory_2
onready var tutorial = $tutorial

onready var playerNameInput = $playerNaming/playerNameEntry
onready var spouseNameInput = $spouseNaming/spouseNameEntry
onready var babyNameInput = $babyNaming/babyNameEntry

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_NewGameButton_pressed():
	menu1.visible = false
	backstory_1.visible = true
	state = States.BACKSTORY_1

func _on_backstoryContinue_pressed():
	backstory_1.visible = false
	playerNaming.visible = true
	state = States.PLAYER_NAMING

func _on_playerNameConfirm_pressed():
	playerNaming.visible = false
	spouseNaming.visible = true
	state = States.SPOUSE_NAMING

func _on_spouseNameConfirm_pressed():
	spouseNaming.visible = false
	babyNaming.visible = true
	state = States.BABY_NAMING

func _on_babyNameConfirm_pressed():
	babyNaming.visible = false
	backstory_2.visible = true
	state = States.BACKSTORY_2

func _on_backstory2Continue_pressed():
	backstory_2.visible = false
	tutorial.visible = true
	state = States.TUTORIAL

func _on_tutorialContinue_pressed():
	Helper.player_name = playerNameInput.text
	Helper.spouse_name = spouseNameInput.text
	Helper.baby_name = babyNameInput.text

	get_tree().change_scene("res://HouseV2.tscn")
