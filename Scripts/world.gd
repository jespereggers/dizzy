extends Node2D

onready var player: KinematicBody2D = $player
onready var map: Node2D = $map


func _ready():
	stats.load_backend()
	signals.emit_signal("backend_is_ready")


func _on_screen_area_body_exited(body):
	if body.name == "player":
		# Check if the player left on X-Axis
		if body.position.x < $screen_area.position.x - $screen_area/collision.shape.extents.x:
			# Left
			if databank.maps[stats.current_map].keys().has(Vector2(stats.current_room.x - 1, stats.current_room.y)):
				stats.current_room = Vector2(stats.current_room.x - 1, stats.current_room.y)
				$map.update_map()
				$player.position.x = $screen_area.position.x + $screen_area/collision.shape.extents.x - 5
			else:
				kill_player()
				
		if body.position.x > $screen_area.position.x + $screen_area/collision.shape.extents.x:
			# Right
			if databank.maps[stats.current_map].keys().has(Vector2(stats.current_room.x + 1, stats.current_room.y)):
				stats.current_room = Vector2(stats.current_room.x + 1, stats.current_room.y)
				$map.update_map()
				$player.position.x = $screen_area.position.x - $screen_area/collision.shape.extents.x + 5
			else:
				kill_player()
				
		# Check if the player left on Y-Axis
		if body.position.y < $screen_area.position.y - $screen_area/collision.shape.extents.y:
			# UP
			if databank.maps[stats.current_map].keys().has(Vector2(stats.current_room.x, stats.current_room.y + 1)):
				stats.current_room = Vector2(stats.current_room.x, stats.current_room.y + 1)
				$map.update_map()
				$player.position.y = $screen_area.position.y + $screen_area/collision.shape.extents.y - 15
			else:
				kill_player()
				
		if body.position.y > $screen_area.position.y + $screen_area/collision.shape.extents.y:
			# DOWN
			if databank.maps[stats.current_map].keys().has(Vector2(stats.current_room.x, stats.current_room.y - 1)):
				stats.current_room = Vector2(stats.current_room.x, stats.current_room.y - 1)
				$map.update_map()
				$player.position.y = $screen_area.position.y - $screen_area/collision.shape.extents.y + 15
			else:
				kill_player()
				
		$display.update_display()

func kill_player():
	if stats.eggs > 0:
		stats.eggs -= 1
	signals.emit_signal("eggs_changed")
	map.respawn_player()
