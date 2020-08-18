extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var hour = 0
var minute = 0
const INTERVAL = 1

var energy = 100.0
const ENERGYRATE = 0.8

onready var numberElement = $HBoxContainer/Bars/Bar/Count/Number
onready var energyGuageElement = $HBoxContainer/Bars/Bar/Guage
onready var minHand = $HBoxContainer/Bars/Bar/Count/Title/MinuteHand
onready var hourHand = $HBoxContainer/Bars/Bar/Count/Title/HourHand

# Called when the node enters the scene tree for the first time.
func _ready():
	hour = 7
	minute = 0
	updateUI()
	
func updateEnergy(level):
	energy = level
	updateUI()

func getEnergy():
	return energy

func updateUI():
	numberElement.text = "%02d:%02d" % [hour, minute]
	energyGuageElement.value = energy
	minHand.rect_rotation = minute/60.0*360
	hourHand.rect_rotation = (hour/12.0 + minute/60.0/12 )*360

func _on_Timer_timeout():
	minute += INTERVAL
	if minute > 60:
		minute = 0
		hour += 1
	if hour > 12:
		hour = 1
		
	energy -= ENERGYRATE
	updateUI()
