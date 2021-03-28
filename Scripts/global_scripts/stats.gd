extends Node

var inventory: Array = []
var coins: int
var eggs: int
var current_map: int
var current_room: Vector2


func _ready():
	signals.connect("player_died", self, "_on_player_died")
	signals.connect("coin_collected", self, "_on_coin_collected")


func load_backend():
	coins = 0
	eggs = databank.max_eggs
	current_map = 1
	current_room = Vector2(0,0)


func _on_coin_collected():
	coins += 1
	signals.emit_signal("coins_changed")


func _on_player_died(_colliding_object: String):
	change_eggs_by(-1)


func change_eggs_by(amount: int):
	if amount == 0:
		return
		
	eggs = clamp(eggs + amount, 0, databank.max_eggs)

	signals.emit_signal("eggs_changed")
