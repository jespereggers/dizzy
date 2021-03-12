extends Sprite

var overlaping_with_player: bool = false


func _input(event):
	if Input.is_action_pressed("select"):
		if overlaping_with_player:
			stats.coins += 1
			signals.emit_signal("coins_changed")
			#signals.emit_signal("show_default_popup", {"Sehr Gut!": Color(1,1,1,1), "Du hast eine Münze gefunden": Color(1,1,1,1)})
			self.queue_free()


func _on_area_body_entered(body):
	if body.name == "player":
		overlaping_with_player = true


func _on_area_body_exited(body):
	if body.name == "player":
		overlaping_with_player = false
