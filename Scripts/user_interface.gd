extends CanvasLayer

onready var death: Popup = $death
onready var found_countable: Popup = $found_countable
onready var inventory: Popup = $inventory

var locked: bool = false
var player_on_item: bool = false


func dialogue_event(event: String = ""):
	match event:
		"found_coin":
			pass
