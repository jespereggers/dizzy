extends Item

var picked_up_once = false

func _ready():
		._ready()
		properties_to_save.append("picked_up_once")

func snap_to_position():
		.snap_to_position()
		#special rule for room 5
		if not picked_up_once:
			if position.y == 120:
					position.x = 213

func get_picked_up():
		picked_up_once = true
