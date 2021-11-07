extends Node2D

onready var player: Area2D = $player
onready var map: Node2D = $map

enum LANGUAGES {english, german}
export(LANGUAGES) var language = LANGUAGES.english
export var paused: bool = false

func _ready():
	var texture_test: AnimatedTexture = load("res://Assets/tiles/objects/torchfire.tres")
	texture_test.pause = true
			
	paths.world_root = self
	paths.player = $player
	paths.camera = $camera
	paths.map = $map
	paths.display = $display
	paths.settings = $overlay/settings
	paths.ui = $map/user_interface
	
	data.load_game()
	stats.load_backend()

	if player.connect("left_room", self, "_on_player_left_room") != OK:
		print("Error occured when trying to establish a connection")
	signals.emit_signal("backend_is_ready")

func _on_player_left_room(dir:Vector2):
	var new_room_coords = stats.current_room + dir
	if data.maps[stats.current_map].keys().has(new_room_coords):
		stats.current_room = new_room_coords
		$map.update_map()
		$display.update_display()
	else:
		stats.change_eggs_by(-1)
	

#func _on_screen_area_area_exited(area):
#	return
#	if area.name == "player":
#		# Check if the player left on X-Axis
#		var player_height: float = paths.player.position.y
#
#		if area.position.x < $screen_area.position.x - $screen_area/collision.shape.extents.x:
#			# Left
#			if data.maps[stats.current_map].keys().has(Vector2(stats.current_room.x - 1, stats.current_room.y)):
#				$player.position.x = $screen_area.position.x + $screen_area/collision.shape.extents.x - 10
#				stats.current_room = Vector2(stats.current_room.x - 1, stats.current_room.y)
#				$map.update_map()
#				yield($map, "room_entered_tree")
#				paths.player.position.y = player_height
#			else:
#				stats.change_eggs_by(-1)
#
#		if area.position.x > $screen_area.position.x + $screen_area/collision.shape.extents.x:
#			# Right
#			if data.maps[stats.current_map].keys().has(Vector2(stats.current_room.x + 1, stats.current_room.y)):
#				stats.current_room = Vector2(stats.current_room.x + 1, stats.current_room.y)
#				$map.update_map()
#				paths.player.position.y = player_height
#				$player.position.x = $screen_area.position.x - $screen_area/collision.shape.extents.x + 10
#				yield($map, "room_entered_tree")
#				paths.player.position.y = player_height
#			else:
#				stats.change_eggs_by(-1)
#
#		# Check if the player left on Y-Axis
#		if area.position.y < $screen_area.position.y - $screen_area/collision.shape.extents.y:
#			# UP
#			if data.maps[stats.current_map].keys().has(Vector2(stats.current_room.x, stats.current_room.y + 1)):
#				$player.position.y = $screen_area.position.y + $screen_area/collision.shape.extents.y - 15
#				stats.current_room = Vector2(stats.current_room.x, stats.current_room.y + 1)
#				$map.update_map()
#			else:
#				stats.change_eggs_by(-1)
#
#		if area.position.y > $screen_area.position.y + $screen_area/collision.shape.extents.y:
#			# DOWN
#			if data.maps[stats.current_map].keys().has(Vector2(stats.current_room.x, stats.current_room.y - 1)):
#				$player.position.y = $screen_area.position.y - $screen_area/collision.shape.extents.y + 15
#				stats.current_room = Vector2(stats.current_room.x, stats.current_room.y - 1)
#				$map.update_map()
#			else:
#				stats.change_eggs_by(-1)
#
#		$display.update_display()
