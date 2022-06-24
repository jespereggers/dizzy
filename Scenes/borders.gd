extends Node2D

var paused: bool = false
var cooldown: bool = true

const MAP_CHANGE_ENTRY_LEFT = 20
const MAP_CHANGE_ENTRY_RIGHT = 236
const MAP_CHANGE_ENTRY_BOTTOM = 163
const MAP_CHANGE_ENTRY_TOP = 49


func _on_border_entered(collider, border):
	if collider.name != "player": # Filter
		return
		
	if cooldown:
		paused = true

	if paused:
		return

	var dir := Vector2()
	var pos := paths.player.position
	
	match border:
		"left":
			dir.x -= 1
			pos.x = MAP_CHANGE_ENTRY_RIGHT
		"right":
			dir.x += 1
			pos.x = MAP_CHANGE_ENTRY_LEFT
		"top":
			dir.y += 1
			pos.y = MAP_CHANGE_ENTRY_BOTTOM
		"bottom":
			dir.y -= 1
			pos.y = MAP_CHANGE_ENTRY_TOP
	if not paths.player.stick_to_boat:
		paths.player.position = pos
	paths.world._on_player_left_room(dir)


func _on_border_left(area):
	if area.name != "player": # Filter
		return

	if paused:
		paused = false


func _on_player_visibility_changed():
	cooldown = true
	run_cooldown()


func run_cooldown():
	yield(get_tree().create_timer(0.2), "timeout")
	cooldown = false
