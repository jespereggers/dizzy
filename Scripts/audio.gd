extends Node


func _ready():
	signals.connect("countable_collected", self, "_on_countable_collected")
	$coin.stream.set_loop(false)
	$dead.stream.set_loop(false)
	$intro.stream.set_loop(false)
	$theme.stream.set_loop(false)
	
	#for i in get_children():
		#i.play()
		#i.stream_paused = true
	play("theme")


func play(audio_name: String):
	var new_audio = audio_name
	for audio_instance in get_children():
		if not audio_instance.name == audio_name:
			audio_instance.stream_paused = true
			#audio_instance.stop()
	get_node(new_audio).stream_paused = false
	get_node(new_audio).play(get_node(new_audio).get_playback_position())
	#$coin.get_playback_position()
		#if audio_instance.name == audio_name:
		#	get_node(audio_name).play(0.0)
		#	audio_instance.stream_paused = false
		#else:
		#	audio_instance.seek(0.0)
		#	audio_instance.stream_paused = true
	
	
func _on_countable_collected(_coin_instance):
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
