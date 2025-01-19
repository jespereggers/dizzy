extends Persistent

func disable():
		visible = false
		get_node("interactable/shape").disabled = true
		queue_free()

func enable():
		visible = true


