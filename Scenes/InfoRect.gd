extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _gui_input(event):
		if event.is_action_released("left_mouse_button"):
				hide()
				get_node("../TapToClosePanel").hide()
