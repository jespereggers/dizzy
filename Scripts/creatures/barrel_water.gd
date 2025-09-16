extends Persistent

var disabled:bool = true setget _set_disabled

func _set_disabled(val:bool):
		disabled = val
		visible = !val
		$shape.disabled = val
		get_node("interactable/shape").disabled = val
		
func disable():
		_set_disabled(true)
		
func enable():
		_set_disabled(false)
