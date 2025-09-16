extends Persistent

var disabled:bool = true setget _set_disabled

func _set_disabled(val:bool):
		print("set disabled to:")
		print(val)
		disabled = val
		visible = !val
		$shape.disabled = val
		get_node("interactable/shape").disabled = val
		
		#if stats.game_state.shared_scene_data.has("barrel_boat_disabled"):
		#	stats.game_state.shared_scene_data["barrel_boat_disabled"] = !val

		
func disable():
		_set_disabled(true)
		
func enable():
		_set_disabled(false)
