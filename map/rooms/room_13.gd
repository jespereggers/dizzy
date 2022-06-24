extends Node2D


func _ready():
	if paths.player.keep_sticked_to_boat:
		paths.player.position = $barrel_boat.global_position
		paths.player.position.x += 10
		paths.player.position.y -= 20
		paths.player.stick_to_boat = true
	
	if data.clock.barrel_boat_state.empty():
		$barrel_boat.hide()
