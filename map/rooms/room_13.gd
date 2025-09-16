extends Node2D


func _ready():
	if stats.game_state.shared_scene_data.has("barrel_boat_disabled"):
		$barrel_boat.disabled = stats.game_state.shared_scene_data["barrel_boat_disabled"]
		
	if $barrel_boat.disabled:
		print("disable")
		$animations.play("disable_boat")
	else:
		#if live.prev_room == Vector2(-1, 0):
		$animations.play("move_boat")
			#$animations.advance(1.5)
		#else:
			#$animations.play("move_boat")
	$barrel_boat.show()
	print("visible:")
	print($barrel_boat.visible)
