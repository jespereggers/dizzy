extends Persistent

onready var sprite = $Sprite
onready var interaction_area = $InteractionArea
var state := "untouched"

func _ready():
	interaction_area.dialogue = ["box:room_8/message_lever_on","wait","call:room8_lever:activate"]

func activate() -> void:
	match state:
		"untouched":
			sprite.flip_h = !sprite.flip_h
			interaction_area.dialogue = ["box:room_8/message_lever_off","wait","box:room_8/message_lever_break","wait","call:room8_lever:activate"]
			state = "touched_once"
		"touched_once":
			sprite.flip_h = !sprite.flip_h
			interaction_area.dialogue = ["box:room_8/message_lever_on_off","wait","call:room8_lever:activate"]
			state = "touched_twice"
		"touched_twice":
			sprite.flip_h = !sprite.flip_h
			interaction_area.dialogue = ["box:room_8/message_lever_crack","wait","box:room_8/message_lever_broken","wait","call:room8_lever:queue_free"]
		var u:push_error("unknown state: " + str(u))
	
