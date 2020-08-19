extends Control

var day = 0
var hour = 0
var minute = 0
const INTERVAL = 1

var energy = 100.0
const ENERGYRATE = 0.8

onready var numberElement = $margin/HBoxContainer/Bars/Bar/Count/Number
onready var energyGuageElement = $margin/HBoxContainer/Bars/Bar/Guage
onready var minHand = $margin/HBoxContainer/Bars/Bar/Count/Title/MinuteHand
onready var hourHand = $margin/HBoxContainer/Bars/Bar/Count/Title/HourHand
onready var anim = $AnimationPlayer

onready var dayLabel = $CanvasLayer/CenterContainer/DayLabel
onready var remainingLabel = $CanvasLayer/CenterContainer/RemainingLabel

func _ready():
	hour = 7
	minute = 0
	updateUI()
	
func updateEnergy(level):
	energy = level
	updateUI()

func getEnergy():
	return energy
	
func endDay():
	print("End of day!")
	hour = 7
	minute = 0
	day += 1
	updateUI()
	anim.play("EndOfDay")

func updateUI():
	numberElement.text = "%02d:%02d" % [hour, minute]
	dayLabel.text = "Day: %d" % [day]
	remainingLabel.text = "%d days %d hours %d min remaining" % [9 - day, 24-hour, 60-minute]
	
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
		day += 1
		
	energy -= ENERGYRATE
	updateUI()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "EndOfDay":
		energy = 100
