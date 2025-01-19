extends Node

export var settings : Resource

func _ready():
		assert(settings)
		assert(settings.connect("sound_on_changed",self,"_on_sound_on_changed") == OK)
		$coin.stream.set_loop(false)
		$dead.stream.set_loop(false)
		$intro.stream.set_loop(true)
		$theme.stream.set_loop(true)

var current_stream_player:AudioStreamPlayer

func play(audio_name: String):
		current_stream_player = get_node(audio_name)
		for audio_instance in get_children():
				if audio_instance != current_stream_player:
						audio_instance.stream_paused = true
						audio_instance.stop()
		current_stream_player.stream_paused = false
		current_stream_player.play(0)
	
func stop():
		current_stream_player.stop()

func get_stream_length() -> float:
		return $dead.stream.get_length()

func get_remaining_stream_length() -> float:
		return current_stream_player.stream.get_length() - current_stream_player.get_playback_position()
		
func _on_coin_finished():
		signals.emit_signal("sound_finished","coin")

func _on_dead_finished():
		print(OS.get_ticks_msec(), " dead sound finished")
		#play("theme")
		signals.emit_signal("sound_finished","dead")

func _on_intro_finished():
		pass

func _on_theme_finished():
		pass

func _on_sound_on_changed():
		AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), !settings.sound_on)
		
