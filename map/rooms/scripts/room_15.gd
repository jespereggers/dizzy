extends Node2D

signal enter_pressed


func _ready():
	if signals.connect("new_room_touched", self, "_on_new_room_touched") != OK:
		print("Error occured when trying to establish a connection")


func _on_new_room_touched():
	start_dialogue()


func start_dialogue():
	if "greeting" in data.game_save.finished_dialogues:
		return
	
	signals.emit_signal("pause_mode_changed_to", true)
	paths.player.hide()
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
	paths.player.show()
	get_tree().paused = false
	paths.ui.locked = false


func _input(event):
	if event is InputEventKey and Input.is_action_just_released("enter"):
		emit_signal("enter_pressed")
