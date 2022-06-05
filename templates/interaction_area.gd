extends Area2D

export var trigger_dialogue: bool = false
export var conditions: PoolStringArray = []
export var dialogue: PoolStringArray = []
export var save_state: bool = false

func _input(event):
	if Input.is_action_just_pressed("enter") and not paths.settings.visible and self in paths.player.interaction_detector.findings:
		paths.player.interaction_detector.findings.clear()
		
		# Check Conditions
		for condition in conditions:
			match condition.rsplit(":")[0]:
				"item":
					if not item_in_inventory(condition.rsplit(":")[1]):
						return
				"visible":
					if paths.map.room_node.has_node(condition.rsplit(":")[1]):
						if not paths.map.room_node.get_node(condition.rsplit(":")[1]).visible:
							return
						
		# Run Dialogue
		if trigger_dialogue:
			paths.ui.dialogue.play_custom(dialogue)
		
		# Save State
		if save_state:
			pass


func item_in_inventory(item: String) -> bool:
	for slot in stats.inventory:
		if slot.item_name == item:
			return true
	return false
