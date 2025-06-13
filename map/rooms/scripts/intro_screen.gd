extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
		audio.play("intro")

func _input(event):
		if event.is_action_released("left_mouse_button") or event is InputEventScreenTouch:
				print("change 1: ", data.main_menu_coord)
				paths.map.change_room(data.main_menu_coord)
