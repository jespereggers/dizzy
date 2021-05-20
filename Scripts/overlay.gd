extends CanvasLayer


func _on_open_settings_pressed():
	get_tree().paused = true
	$settings.popup()

