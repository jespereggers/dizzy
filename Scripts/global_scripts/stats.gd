extends Node

var inventory: Array = []
var coins: int
var shards: int
var eggs: int
var current_map: String
var current_room: Vector2


func load_backend():
	inventory = databank.game_save.player.inventory
	coins = databank.game_save.player.coins
	shards = databank.game_save.player.shards
	eggs = databank.game_save.player.eggs
	current_map = databank.game_save.scene.current_map
	current_room = databank.game_save.scene.current_room
	paths.display.update_display()


func change_eggs_by(amount: int):
	if amount == 0:
		return
		
# warning-ignore:narrowing_conversion
	eggs = clamp(eggs + amount, 0, databank.max_eggs)

	signals.emit_signal("eggs_changed")
