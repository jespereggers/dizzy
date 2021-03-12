extends Node

onready var player: KinematicBody2D = get_parent().get_parent()
onready var state_machine: Node = get_parent()

var times_played: int = 0
var times_played_goal: int = 2


func enter():
	player.locked = true
	player.animation.play("jump")
	
	
func _on_animation_finished():
	times_played += 1
	
	if times_played < times_played_goal:
		player.animation.play("jump")
	else:
		times_played = 0
		player.locked = false
