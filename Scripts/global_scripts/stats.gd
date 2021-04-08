extends Node

var inventory: Array = []
var coins: int
var eggs: int
var current_map: int
var current_room: Vector2


func load_backend():
	coins = 0
	eggs = databank.max_eggs
	current_map = 1
	current_room = Vector2(0,0)


func change_eggs_by(amount: int):
	if amount == 0:
		return
		
	eggs = clamp(eggs + amount, 0, databank.max_eggs)

	signals.emit_signal("eggs_changed")
