extends Popup

const LABEL_TEXT = "you lost a life!"


func _ready():
	set_process_unhandled_input(false)


func start(_colliding_object: String):
	get_parent().apply_viewport_to_background()
	get_parent().locked = true
	get_tree().paused = true
	$label.text = LABEL_TEXT
	self.popup()
	set_process_unhandled_input(true)


func _unhandled_input(event):
	if audio.get_node("dead").playing:
		return
		
	if Input.is_action_just_pressed("enter") or event is InputEventScreenTouch:
		if stats.eggs <= 0:
			stats.eggs = databank.max_eggs
			stats.current_room = Vector2(0,0)
			paths.map.update_map()
		else:
			stats.change_eggs_by(-1)
		signals.emit_signal("eggs_changed")
			
		paths.map.respawn_player()
		
		set_process_unhandled_input(false)
		get_tree().paused = false
		hide()
		get_parent().frozen_screen.hide()
		
		yield(get_tree().create_timer(0.2), "timeout")
		get_parent().locked = false
		audio.play("theme")
