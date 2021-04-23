extends CanvasLayer

onready var death: Popup = $death
onready var found_coin: Popup = $found_coin

var locked: bool = false
var player_on_item: bool = false

