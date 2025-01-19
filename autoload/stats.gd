extends Node

export var save_path := "user://savegame.tres"

var settings: Resource = preload("res://resources/default_settings.tres")
onready var game_state : Resource = SaveGame.new() 

var inventory: Array = []
var infinite_eggs := false

func _ready():
		settings.load()
		game_state.eggs = 0
		game_state.coins = 0
		game_state.shards = 0
		game_state.has_artifact = false
		assert(signals.connect("player_is_respawning",self,"_on_player_is_respawning") == OK)
		assert(signals.connect("respawn_position_updated",self,"_on_respawn_position_updated") == OK)
		assert(signals.connect("game_over",self,"_on_game_over") == OK)
		assert(signals.connect("map_loaded",self,"_on_map_loaded") == OK)
		
func persistents_to_dicts(persistents:Array) -> Array:
		var dicts := []
		for persistent in persistents:
				assert(persistent is Persistent)
				dicts.append(persistent.serialize())
		return dicts

func save_game():
	paths.map.serialize_persistents()  
	game_state.inventory = persistents_to_dicts(inventory)
	game_state.walk_idle_shared_frame_counter = paths.player.walk_idle_shared_frame_counter+1
	game_state.rng_state = tools.rng.state
	
func save_to_disk():
		save_game()
		if game_state.current_room is Vector2:
				if not ResourceSaver.save(save_path,game_state) == OK:
						push_error("save to disk failed")
		
func _on_player_is_respawning():
		save_to_disk()

func _on_respawn_position_updated():
		save_to_disk()

func _on_game_over():
		if File.new().file_exists(save_path):
				if not Directory.new().remove(save_path) == OK:
						push_error("deleting save on game over failed")
		game_state.shards = 0
		game_state.coins = 0
		game_state.has_artifact = false

func _input(event):
		if event.is_action_pressed("more_eggs"):
				game_state.eggs = 2

func pick_up_item(item:Item):
		var items_to_swap:Dictionary = {}
		inventory.append(item)
		if inventory.size() > game_state.inventory_capacity: #drop item with lowest priority
				inventory.sort_custom(item,"item_comparision")
				items_to_swap =  {"to_drop":inventory.pop_front(),"to_keep":item}
		return items_to_swap

func remove_item_from_inventory(item:Item) -> void:
		inventory.erase(item)

func inventory_has_item(item_name:String):
		for item in inventory:
				if item.item_name == item_name:
						return true
		return false
		
func _on_map_loaded():
	pass
		#print_debug("map loaded:\nshared_scene_data: " + str(game_state.shared_scene_data))
