extends Node

var current_room: Vector2

var blocked: bool = false



func block(): 
	print("start global block")
	blocked = true
	yield(get_tree().create_timer(0.2), "timeout")
	print("end global block")
	blocked = false
