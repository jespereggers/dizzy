extends CanvasLayer

var paused: bool = false


func _input(event):
	if !paused:
		return
			
	if event is InputEventScreenTouch:
		if event.pressed:
			yield(get_tree().create_timer(0.1), "timeout")
			signals.emit_signal("touch_while_paused")
			print("touched while paused")
			#Input.action_press("enter")
