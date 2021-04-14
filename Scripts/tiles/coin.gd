extends Sprite

var overlaping_with_player: bool = false


func _input(_event):
	if Input.is_action_just_pressed("enter"):
		if overlaping_with_player:
			signals.emit_signal("coin_collected", self)


func _on_area_body_entered(body):
	if body.name == "player":
		overlaping_with_player = true


func _on_area_body_exited(body):
	if body.name == "player":
		overlaping_with_player = false
