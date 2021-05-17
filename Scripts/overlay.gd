extends CanvasLayer


func _on_open_settings_pressed():
	$open_settings.hide()
	
	get_tree().paused = true
	$settings.popup()


func _on_exit_pressed():
	$open_settings.show()
	
	get_tree().paused = false
	$settings.hide()
