extends Node2D

onready var player: KinematicBody2D = $player
onready var map: Node2D = $map


func _ready():
	stats.player = $player
	stats.map = $map
	stats.display = $display
	
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
				stats.change_eggs_by(-1)
				
		if body.position.x > $screen_area.position.x + $screen_area/collision.shape.extents.x:
			# Right
			if databank.maps[stats.current_map].keys().has(Vector2(stats.current_room.x + 1, stats.current_room.y)):
				stats.current_room = Vector2(stats.current_room.x + 1, stats.current_room.y)
				$map.update_map()
				$player.position.x = $screen_area.position.x - $screen_area/collision.shape.extents.x + 5
			else:
				stats.change_eggs_by(-1)
				
		# Check if the player left on Y-Axis
		if body.position.y < $screen_area.position.y - $screen_area/collision.shape.extents.y:
			# UP
			if databank.maps[stats.current_map].keys().has(Vector2(stats.current_room.x, stats.current_room.y + 1)):
				stats.current_room = Vector2(stats.current_room.x, stats.current_room.y + 1)
				$map.update_map()
				$player.position.y = $screen_area.position.y + $screen_area/collision.shape.extents.y - 15
			else:
				stats.change_eggs_by(-1)
				
		if body.position.y > $screen_area.position.y + $screen_area/collision.shape.extents.y:
			# DOWN
			if databank.maps[stats.current_map].keys().has(Vector2(stats.current_room.x, stats.current_room.y - 1)):
				stats.current_room = Vector2(stats.current_room.x, stats.current_room.y - 1)
				$map.update_map()
				$player.position.y = $screen_area.position.y - $screen_area/collision.shape.extents.y + 15
			else:
				stats.change_eggs_by(-1)
				
		$display.update_display()
