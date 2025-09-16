extends Node

var current_room: Vector2 setget set_current_room
var prev_room: Vector2 = Vector2(-1,-1)
var blocked: bool = false
var player_on_leader: bool = false


func block(s=0.2): 
	print("start global block")
	blocked = true
	yield(get_tree().create_timer(s), "timeout")
	print("end global block")
	blocked = false

func set_current_room(value):
	prev_room = current_room
	current_room = value
