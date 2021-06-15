extends Node


func _ready():
	signals.connect("coin_collected", self, "_on_coin_collected")
	$coin.stream.set_loop(false)
	$dead.stream.set_loop(false)
	$intro.stream.set_loop(false)
	$theme.stream.set_loop(false)
	
	play("theme")


func play(audio_name: String):
	var new_audio = audio_name
	for audio_instance in get_children():
		audio_instance.stop()
	get_node(new_audio).play(0)
		#if audio_instance.name == audio_name:
		#	get_node(audio_name).play(0.0)
		#	audio_instance.stream_paused = false
		#else:
		#	audio_instance.seek(0.0)
		#	audio_instance.stream_paused = true
	
	
func _on_coin_collected(_coin_instance):
	play("coin")


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
