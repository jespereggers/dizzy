extends Node2D


func _ready():
	if paths.player.stick_to_boat:
		paths.player.position = $barrel_boat.position
		paths.player.position.y += 16
#	data.clock.connect("barrel_state_changed", self, "on_barrel_boat_state_changed")
	if data.clock.barrel_boat_state.empty():
		$barrel_boat.hide()


#func on_barrel_boat_state_changed(new_state: String):
	#$barrel_boat.show()
#	match new_state:
	#	"room_13_swim_left":
	#		$barrel_boat.hide()
		#"room_13_swim_right":
		#	$barrel_boat.hide()
	#	"room_14_swim_left":
		#	$barrel_boat/animator.play("barrel_boat_swim_left")
	#	"room_14_swim_right":
		#	$barrel_boat/animator.play("barrel_boat_swim_right")


func _on_barrel_boat_placed():
	data.clock.move_barrel_boat()
	print("START")
