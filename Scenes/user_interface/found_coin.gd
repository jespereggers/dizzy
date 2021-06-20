extends Popup

var countable_instance: Sprite


func _ready():
	set_process_unhandled_input(false)
	signals.connect("countable_collected", self, "_on_countable_collected")


func _on_countable_collected(new_countable_instance):
	get_parent().locked = true
	signals.emit_signal("pause_mode_changed_to", true)
	countable_instance = new_countable_instance
	paths.player.hide()
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
		signals.emit_signal("pause_mode_changed_to", false)
		var type = countable_instance.type
		countable_instance.queue_free()
		yield(get_tree().create_timer(0.1), "timeout")
		get_parent().locked = false
		
		match type:
			"coin":
				stats.coins += 1
				signals.emit_signal("coins_changed")
			"shard":
				stats.shards += 1
				signals.emit_signal("shards_changed")

		audio.play("theme")
