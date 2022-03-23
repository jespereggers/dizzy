extends CanvasLayer

onready var dialogue: Control = $dialogue_system
#onready var found_countable: Popup = $found_countable
onready var inventory: Popup = $inventory

var locked: bool = false
var player_on_item: bool = false
