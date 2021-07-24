extends Node


func _ready():
	if signals.connect("countable_collected", self, "_on_countable_collected") != OK:
		print("Error occured when trying to establish a connection")
	$coin.stream.set_loop(false)
	$dead.stream.set_loop(false)
	$intro.stream.set_loop(false)
	$theme.stream.set_loop(false)
	play("theme")


func play(audio_name: String):
	var new_audio = audio_name
	for audio_instance in get_children():
		if not audio_instance.name == audio_name:
			audio_instance.stream_paused = true
			audio_instance.stop()
	get_node(new_audio).stream_paused = false
	get_node(new_audio).play(0)
	
	
func _on_countable_collected(_coin_instance):
	play("coin")
	yield(get_tree().create_timer(2.55), "timeout")


func _on_coin_finished():
	pass


func _on_dead_finished():
	pass


func _on_intro_finished():
	if not $dead.playing:
		$theme.play()


func _on_theme_finished():
	if not $dead.playing:
		$theme.play()
