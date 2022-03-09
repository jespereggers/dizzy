extends Node2D

signal enter_pressed


func _ready():
	start_dialogue()

func start_dialogue():
	if "greeting" in data.game_save.finished_dialogues:
		return
	
	signals.emit_signal("pause_mode_changed_to", true)
	paths.player.script_locked = true
	paths.player.visible = false
	get_tree().paused = true
	paths.ui.locked = true
	
	for phase in data.dialogues["greeting"]:
		for popup in phase:
			if popup == "clear":
				for popup_instance in $popups.get_children():
					popup_instance.hide()
			else:
				$popups.get_node(popup + "_" + TranslationServer.get_locale()).rect_position = Vector2(8, 48)
				$popups.get_node(popup + "_" + TranslationServer.get_locale()).popup()
				
		yield(self, "enter_pressed")
	
	for popup_instance in $popups.get_children():
		popup_instance.hide()
	data.game_save.finished_dialogues.append("greeting")
	
	signals.emit_signal("pause_mode_changed_to", false)
	paths.player.script_locked = false
	paths.player.visible = true
	paths.player.respawn()
	get_tree().paused = false
	paths.ui.locked = false


func _input(event):
	if event is InputEventKey and Input.is_action_just_released("enter"):
		emit_signal("enter_pressed")
