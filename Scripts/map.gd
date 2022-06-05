extends Node2D

onready var root: Node2D = get_parent()
signal maps_cleaned
signal map_loaded

export var default_respawn: Vector2 = Vector2(220,134)
#export var custom_respawn_correction: Vector2 = Vector2(8, 48)

var room_node:Node2D = null

const BLACKSCREEN_DURATION = 0.4 #map change

func _ready():
	yield(signals, "backend_is_ready")
	_load_map()
	
func change_room(new_room_coords:Vector2):
	if paths.player.stick_to_boat:
		paths.player.keep_sticked_to_boat = true
		manage_player_keep_sticked_to_boat()
	if not data.maps[stats.current_map].keys().has(new_room_coords):
		push_error("Error: Can't load nonexisting room")
	_clean_maps()
	stats.current_room = new_room_coords
	yield(get_tree().create_timer(BLACKSCREEN_DURATION), "timeout") #blackscreen
	_load_map()
	paths.display.update_display()


func manage_player_keep_sticked_to_boat():
	yield(get_tree().create_timer(3.0), "timeout")
	paths.player.keep_sticked_to_boat = false


func _clean_maps():
	for room in get_children():
		#if str(room.filename) != data.maps[stats.current_map][stats.current_room].path and room.name != "user_interface":
		if room.name != "user_interface":
			_unload_items(room)
			room.queue_free()
	emit_signal("maps_cleaned")


func _load_map():
	room_node = load(data.maps[stats.current_map][stats.current_room].path).instance()
	add_child(room_node)
	_load_items(room_node)
	emit_signal("map_loaded")

func _unique_item_string(item:Node2D):
	return item.name + str(item.position)

func _load_items(room:Node):
	if not stats.current_room in data.game_save.enviroment[stats.current_map]:
		data.game_save.enviroment[stats.current_map][stats.current_room] = {"removed_items": [], "remembered_items": []}
	#remove and remember items
	for child in room.get_children():
		if (child is Item) or (child is Coin):
			var unique_item_string = _unique_item_string(child)
			if not data.game_save.enviroment[stats.current_map][stats.current_room].removed_items.has(unique_item_string):
				data.game_save.enviroment[stats.current_map][stats.current_room].removed_items.append(unique_item_string)
				data.game_save.enviroment[stats.current_map][stats.current_room].remembered_items.append(child)
			room.remove_child(child)
		#place remembered items
	for item in data.game_save.enviroment[stats.current_map][stats.current_room].remembered_items:
		room.add_child(item)
	data.game_save.enviroment[stats.current_map][stats.current_room].remembered_items = []
		
func _unload_items(room:Node):
	#remember items
	for child in room.get_children():
		if (child is Item) or (child is Coin):
			data.game_save.enviroment[stats.current_map][stats.current_room].remembered_items.append(child)
			room.remove_child(child)

func add(properties: Dictionary):
	var object
	
	match properties.type:
		"item":
			object = load("res://templates/item.tscn").instance()
			object.set_properties(properties)
			object.load_template()
			object.update_pos()
	tools.add_object(object)
	
	for node in get_children():
		if "room" in node.name:
			node.get_node("objects").add_child(object)
			break


func remove(object):
	for node in get_children():
		if "room" in node.name:
			node.get_node("objects").remove_child(object)
			break

