extends Node2D

onready var player: KinematicBody2D = $player
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

	
	signals.emit_signal("backend_is_ready")


func _on_screen_area_body_exited(body):
	if body.name == "player":
		# Check if the player left on X-Axis
		var player_height: float = paths.player.position.y

		if body.position.x < $screen_area.position.x - $screen_area/collision.shape.extents.x:
			# Left
			if data.maps[stats.current_map].keys().has(Vector2(stats.current_room.x - 1, stats.current_room.y)):
				$player.position.x = $screen_area.position.x + $screen_area/collision.shape.extents.x - 5
				stats.current_room = Vector2(stats.current_room.x - 1, stats.current_room.y)
				$map.update_map()
				yield($map, "room_entered_tree")
				paths.player.position.y = player_height
			else:
				stats.change_eggs_by(-1)
				
		if body.position.x > $screen_area.position.x + $screen_area/collision.shape.extents.x:
			# Right
			if data.maps[stats.current_map].keys().has(Vector2(stats.current_room.x + 1, stats.current_room.y)):
				stats.current_room = Vector2(stats.current_room.x + 1, stats.current_room.y)
				$map.update_map()
				paths.player.position.y = player_height
				$player.position.x = $screen_area.position.x - $screen_area/collision.shape.extents.x + 5
				yield($map, "room_entered_tree")
				paths.player.position.y = player_height
			else:
				stats.change_eggs_by(-1)
				
		# Check if the player left on Y-Axis
		if body.position.y < $screen_area.position.y - $screen_area/collision.shape.extents.y:
			# UP
			if data.maps[stats.current_map].keys().has(Vector2(stats.current_room.x, stats.current_room.y + 1)):
				$player.position.y = $screen_area.position.y + $screen_area/collision.shape.extents.y - 15
				stats.current_room = Vector2(stats.current_room.x, stats.current_room.y + 1)
				$map.update_map()
			else:
				stats.change_eggs_by(-1)
				
		if body.position.y > $screen_area.position.y + $screen_area/collision.shape.extents.y:
			# DOWN
			if data.maps[stats.current_map].keys().has(Vector2(stats.current_room.x, stats.current_room.y - 1)):
				$player.position.y = $screen_area.position.y - $screen_area/collision.shape.extents.y + 15
				stats.current_room = Vector2(stats.current_room.x, stats.current_room.y - 1)
				$map.update_map()
			else:
				stats.change_eggs_by(-1)

		$display.update_display()
