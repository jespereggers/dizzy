extends Node2D

export var switch_room: bool setget _on_switch_room


func _ready():
	print(data.clock.barrel_boat_state)
	if paths.player.keep_sticked_to_boat:
		paths.player.position = $barrel_boat.global_position
		paths.player.position.x = -18
		paths.player.position.x += 10
		paths.player.position.y -= 20
		paths.player.stick_to_boat = true
	
	if data.clock.barrel_boat_state.empty():
		$barrel_boat.hide()
	
	return
	
	
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


func _on_switch_room(new_value: bool) -> void:
	paths.world.border.paused = new_value
	switch_room = new_value
