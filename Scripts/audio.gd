extends Node


func _ready():
	signals.connect("coin_collected", self, "_on_coin_collected")
	signals.connect("player_died", self, "_on_player_died")
	$coin.stream.set_loop(false)
	$dead.stream.set_loop(false)
	$intro.stream.set_loop(false)
	$theme.stream.set_loop(false)
	
	play("theme")


func play(audio_name: String):
	for audio_instance in get_children():
		if audio_instance.name == audio_name:
			get_node(audio_name).play(0.0)
			audio_instance.stream_paused = false
		else:
			audio_instance.stream_paused = true
	
	
func _on_coin_collected(_coin_instance):
	play("coin")
	
	
func _on_player_died(_colliding_object):
	play("dead")


func _on_coin_finished():
	pass


func _on_dead_finished():
	pass


func _on_intro_finished():
	$theme.play()


func _on_theme_finished():
	$theme.play()
