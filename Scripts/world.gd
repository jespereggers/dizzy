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

