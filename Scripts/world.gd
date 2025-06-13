extends Node2D

export var user_interface_pck_scene : PackedScene
export var player_pck_scene : PackedScene

func _ready():
		paths.world_root = self
		paths.camera = $camera
		paths.map = $map
		paths.display = $display
		assert(signals.connect("game_to_load_selected",self,"_on_game_to_load_selected") == OK)
		assert(signals.connect("game_over",self,"_on_game_over") == OK)
		
		paths.map.change_room(data.intro_screen_coord)


func _on_player_left_room(dir:Vector2):
		var new_room_coords = stats.game_state.current_room + dir
		if data.maps[stats.game_state.current_map].keys().has(new_room_coords):
				paths.map.change_room(new_room_coords)
		else:
				paths.player.kill("out of bounds")

func dicts_to_persistents(dicts:Array) -> Array:
		var result:Array = []
		for dict in dicts:
				result.append(Persistent.deserialize(dict,null))
		return(result)

func _on_game_to_load_selected(save_game:SaveGame,respawn = true):
		_end_game()
		stats.game_state = save_game
		#restore inventory
		stats.inventory = dicts_to_persistents(stats.game_state.inventory)
		#restore rng state
		tools.rng.state = stats.game_state.rng_state
		#print_debug("Loaded:\n",  stats.game_state.persistents.get(stats.game_state.current_map))
		paths.map._enter_room(stats.game_state.current_room)
		audio.stop()
		yield(signals,"map_loaded")
		var player = player_pck_scene.instance()
		add_child(player)
		player.connect("left_room", self, "_on_player_left_room")
		paths.player = player
		
		var user_interface = user_interface_pck_scene.instance()
		add_child(user_interface)
		paths.ui = user_interface
		if respawn:
			signals.emit_signal("dialogue_triggered",["respawn","await:player_respawned"])
		else:
			player.position = save_game.respawn_position
		player.walk_idle_shared_frame_counter = stats.game_state.walk_idle_shared_frame_counter
		signals.emit_signal("game_started")
		
func _on_game_over():
		yield(paths.ui,"game_resumed")
		_end_game()
		paths.map.change_room(data.intro_screen_coord)
		yield(signals,"map_loaded")
		
func _end_game():
	paths.map._leave_room()
	if paths.player:
				paths.player.queue_free()
				paths.player = null
	if paths.ui:
			paths.ui.queue_free()
			paths.ui = null
