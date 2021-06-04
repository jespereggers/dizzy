extends CanvasLayer

onready var death: Popup = $death
onready var found_coin: Popup = $found_coin
onready var inventory: Popup = $inventory

var locked: bool = false
var player_on_item: bool = false
