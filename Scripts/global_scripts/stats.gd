extends Node

var inventory: Array = []
var inventory_capacity := 2
var coins: int
var shards: int
var eggs: int setget set_eggs
var current_map: String
var current_room: Vector2

var infinite_eggs := false

func _input(event):
	if event.is_action_pressed("more_eggs"):
		self.eggs = data.max_eggs

func load_backend():
	inventory = data.game_save.player.inventory
	coins = data.game_save.player.coins
	shards = data.game_save.player.shards
	eggs = data.game_save.player.eggs
	current_map = data.game_save.scene.current_map
	current_room = data.game_save.scene.current_room
	paths.display.update_display()

func set_eggs(value: int):
	eggs = value
# warning-ignore:narrowing_conversion
	eggs = clamp(eggs, 0, data.max_eggs)
	signals.emit_signal("eggs_changed")

func add_item_to_inventory(item:Item) -> Item:
	print("add item")
	inventory.append(item)
	if inventory.size() > inventory_capacity: #drop item with lowest priority
		inventory.sort_custom(item,"item_comparision")
		return inventory.pop_front()
	else:
		return null

func remove_item_from_inventory(item:Item) -> void:
	inventory.erase(item)
