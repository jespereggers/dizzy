extends Node

var player: KinematicBody2D
var map: Node2D

var coins: int
var eggs: int
var current_map: int
var current_room: Vector2


func load_backend():
	coins = 0
	eggs = 3
	current_map = 1
	current_room = Vector2(0,0)


func change_eggs_by(amount: int):
	if amount == 0:
		return
		
	eggs = clamp(eggs + amount, 0, 3)

	# Play Death-animation
	player.set_physics_process(false)
	player.animations.play("death")
	yield(player.animations, "animation_finished")
	player.scale.x = 0.75
	player.scale.y = 0.75
		
	# Respawn Player
	if eggs == 0:
		eggs = 3
		current_room = Vector2(0,0)
		map.update_map()
	map.respawn_player()
	player.set_physics_process(true)

	signals.emit_signal("eggs_changed")
