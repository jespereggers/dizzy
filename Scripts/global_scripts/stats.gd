extends Node

var inventory: Array = ["Stale Loaf of bread", "Apple"]
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
	paths.player.set_physics_process(false)
	paths.player.animations.play("death")
	yield(paths.player.animations, "animation_finished")
	paths.player.scale.x = 0.75
	paths.player.scale.y = 0.75
		
	# Respawn Player
	if eggs == 0:
		eggs = 3
		current_room = Vector2(0,0)
		paths.map.update_map()
	paths.map.respawn_player()
	paths.display.update_display()
	paths.player.set_physics_process(true)

	signals.emit_signal("eggs_changed")
