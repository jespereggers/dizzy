extends Popup

const LABEL_TEXT = "you lost a life!"


func _ready():
	set_process_unhandled_input(false)


func start(_colliding_object: String):
	signals.emit_signal("pause_mode_changed_to", true)
	get_parent().locked = true
	get_tree().paused = true
	$label.text = LABEL_TEXT
	self.popup()
	set_process_unhandled_input(true)
	yield(audio.get_node("dead"), "finished")
	close()
	


func close():
		if stats.eggs <= 0:
			stats.eggs = databank.max_eggs
			if stats.current_room != Vector2(0,0):
				stats.current_room = Vector2(0,0)
				paths.map.update_map()
		else:
			stats.change_eggs_by(-1)
		signals.emit_signal("eggs_changed")
			
		paths.map.respawn_player()
		
		set_process_unhandled_input(false)
		get_tree().paused = false
		hide()
		signals.emit_signal("pause_mode_changed_to", false)
		
		yield(get_tree().create_timer(0.2), "timeout")
		get_parent().locked = false
		audio.play("theme")
