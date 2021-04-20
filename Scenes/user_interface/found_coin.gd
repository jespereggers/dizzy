extends Popup

var coin_instance: Sprite


func _ready():
	set_process_unhandled_input(false)
	signals.connect("coin_collected", self, "_on_coin_collected")


func _on_coin_collected(new_coin_instance):
	get_parent().apply_viewport_to_background()
	coin_instance = new_coin_instance
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
		get_parent().frozen_screen.hide()
		
		yield(get_tree().create_timer(0.2), "timeout")
		get_parent().locked = false
		coin_instance.queue_free()
		stats.coins += 1
		signals.emit_signal("coins_changed")
		audio.play("theme")
