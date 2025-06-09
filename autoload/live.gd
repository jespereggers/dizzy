extends Node

var current_room: Vector2

var blocked: bool = false



func block(s=0.2): 
	print("start global block")
	blocked = true
	yield(get_tree().create_timer(s), "timeout")
	print("end global block")
	blocked = false
