extends Node2D

onready var baby = Helper.get_baby()

var spouse_might_leave = false

func _process(delta):
	$HappyGuage.value = Helper.spouse_happiness
	
	if spouse_might_leave:
		$EndPanel/Value.text = "%.2f" % $SpouseLeavingTime.time_left
	
	$Help.text = get_help_text()

func get_help_text() -> String:
	var msg = ""
	
	var count = get_tree().get_nodes_in_group("trash").size()
	if count > 0:
		msg += "Unhappy with %d pieces of trash.\n" % [count]
	
	if !baby.is_happy():
		msg += "Unhappy with baby crying."
	
	return msg

func _on_Timer_timeout():
	# Check for trash
	var count = get_tree().get_nodes_in_group("trash").size()
	if count > 0:
		# This makes your spouse upset.
		Helper.spouse_happiness -= Helper.spouse_trash_hatred_per_item_per_min * min(count, 2)

	# Check baby's state.
	if !baby.is_happy():
		Helper.spouse_happiness -= Helper.spouse_crying_hatred_per_min

	if count <= 0 and baby.is_happy():
		# This makes your spouse happy.
		Helper.spouse_happiness += Helper.spouse_trash_hatred_per_item_per_min * 2.0

	# Check if spouse is very upset and might leave.
	if Helper.spouse_happiness <= 0:
		if !spouse_might_leave:
			Helper.notify("%s is very unhappy and will leave you." % Helper.spouse_name)
			spouse_might_leave = true
			$SpouseLeavingTime.start()
			$EndPanel.visible = true
	else:
		spouse_might_leave = false
		$SpouseLeavingTime.stop()
		$EndPanel.visible = false

func _on_SpouseLeavingTime_timeout():
	#Helper.notify("%s has left you." % Helper.spouse_name)
	Helper.trigger_game_over("%s left you and took %s." % [Helper.spouse_name, Helper.baby_name], false)
