extends Area2D

export var trigger_dialogue: bool = false
export var dialogue: PoolStringArray = []
export var save_state: bool = false

func _input(event):
	if Input.is_action_just_pressed("enter") and not paths.settings.visible and not paths.player.interaction_detector.findings.empty():
		
		# Run Dialogue
		if trigger_dialogue:
			paths.ui.dialogue.play_custom(dialogue)
		
		# Save State
		if save_state:
			pass
