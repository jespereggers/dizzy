extends Node


var coins: int
var eggs: int
var current_map: int
var current_room: Vector2


func load_backend():
	coins = 0
	eggs = 3
	current_map = 1
	current_room = Vector2(0,0)
