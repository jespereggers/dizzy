extends Persistent

export var disabled := true setget set_disabled

func set_disabled(value):
	disabled = value
	stats.game_state.shared_scene_data["barrel_boat_disabled"] = value
	signals.emit_signal("barrel_boat_disabled_changed")


func disable():
	set_disabled(true)

func enable():
	set_disabled(false)
