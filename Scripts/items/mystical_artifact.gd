extends Item

#
#func get_dropped():
#  paths.camera.call_deferred("shake")

func get_picked_up():
		stats.game_state.has_artifact = true
		queue_free()

