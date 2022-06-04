extends Timer

var barrel_boat_state: String
var barrel_boat_moving: bool = false
var barrel_boat_events: Array = [
	{"name": "room_14_swim_left", "direction": "left", "room": 14, "duration": 8},
	{"name": "room_13_swim_left", "direction": "left", "room": 13, "duration": 8},
	{"name": "room_13_swim_right", "direction": "right", "room": 13, "duration": 8},
	{"name": "room_14_swim_right", "direction": "right", "room": 14, "duration": 8}
	]

signal barrel_state_changed(state_name)


func move_barrel_boat():
	barrel_boat_moving = true
	self.start(32.0)
	
	for state in barrel_boat_events:
		barrel_boat_state = state.name
		print(state.name)
		emit_signal("barrel_state_changed", state.direction, state.room)
		yield(get_tree().create_timer(float(state.duration)), "timeout")


func _on_clock_timeout():
	if barrel_boat_moving:
		move_barrel_boat()
