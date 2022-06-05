extends Node2D


func _ready():
	#print(paths.player.stick_to_boat)
	#if paths.player.stick_to_boat:
	#	print("STICK")
	#	print(paths.player.global_position)
	##	paths.player.global_position = $barrel_boat.global_position
	#	paths.player.position.y += 16
	#data.clock.connect("barrel_state_changed", self, "on_barrel_boat_state_changed")
	if data.clock.barrel_boat_state.empty():
		$barrel_boat.hide()
		
	#yield(get_tree().create_timer(0.5), "timeout")
#	print(paths.player.global_position)


#func on_barrel_boat_state_changed(new_state: String):
	#$barrel_boat.show()
	#match new_state:
	#	"room_13_swim_left":
	#		$barrel_boat/animator.play("barrel_boat_swim_left")
	#	"room_13_swim_right":
	#		$barrel_boat/animator.play("barrel_boat_swim_right")
	#	"room_14_swim_left":
	#		$barrel_boat.hide()
	#	"room_14_swim_right":
	#		$barrel_boat.hide()
