extends Popup


func _ready():
	set_process_unhandled_input(false)
	signals.connect("coin_collected", self, "_on_coin_collected")


func _on_coin_collected():
	paths.player.hide()
	get_parent().locked = true
	get_tree().paused = true
	self.popup()
	yield(get_tree().create_timer(0.2), "timeout")
	set_process_unhandled_input(true)


func _unhandled_input(event):
	if Input.is_action_just_pressed("enter") or event is InputEventScreenTouch:
		set_process_unhandled_input(false)
		get_tree().paused = false
		paths.player.show()
		hide()
		
		yield(get_tree().create_timer(0.2), "timeout")
		get_parent().locked = false
