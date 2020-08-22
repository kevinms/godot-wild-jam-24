extends Node2D

onready var baby = Helper.get_baby()

func _process(delta):
	$HappyGuage.value = Helper.spouse_happiness

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
